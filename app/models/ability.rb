class Ability
  include CanCan::Ability
  # valid roles [super,coordinator,admin,inviter,scorer,upload,member,guest]
  def initialize(user)
    user ||= User.new  
    cannot :manage, Group  
    can [:read, :print, :pot], :all
    can :update, Member do |member|  
      member.try(:user) == user  
    end 
    can :update, User do |u|  
      u.try(:user) == user  
    end 
    if user.role? [:scorer]
      can [:update, :create,:teeopt], Member  
      can [:update, :create], Round
    end
    if user.role? [:inviter]
      can [:invite], Member  
    end
    if user.role? [:poster]
      can [:manage], Article  
    end
    
    if user.role? [:upload]
      can [:update, :create, :upload], Image
    end
    if user.role? [:admin]
      can [:update, :create, :invite,:teeopt], Member  
      #can [:update, :create], Course  
      #can [:update, :create], Round
      #can [:update, :create, :upload], Image
    end
    if  user.role? [:coordinator]
      can :manage, :all
      can :update,  Group 
      cannot [:create,:destroy], Group  
    end
    if user.role? [:super]  
      can :manage, :all 
    end
    
  end
end
