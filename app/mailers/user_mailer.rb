class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user  
    mail :to => user.email, :subject => "Password Reset"  
  end
  
  def invite_member(user)
    @user = user
    mail :to => user.email, :subject => "Invitation" 
  end 
  
  def register_group(uid)
    @user = User.find(uid)
    mail :to => @user.email, :subject => "Registration" 
  end
end
