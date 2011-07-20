class ApplicationController < ActionController::Base
  include UrlHelper
  
  include ControllerAuthentication
  protect_from_forgery
  
  helper_method :current_group, :is_root_domain?, :is_group_resource?, :is_my_group?
  before_filter :current_group
  before_filter :set_mailer_url_options
  
  #before_filter :set_mailer_url_options

  #def can_sign_up?
    # return true if config.allow_group_sign_up is set to true
  	# Used in conjection with is_root_domain? for root domain.
    #is_root_domain? ? true :Group::CAN_SIGN_UP
  #end
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to opps_url, :alert => exception.message
  end
  
  def check_group_id
    return current_group ? current_user.group.id == current_group.id : false
  end
   
  def is_group_resource?(group_id)
  	# call in controller before_filter to make sure the resource belongs to the group
  	# used to prevent url modification to resources that are not owned by group.
    if group_id != current_group.id
      redirect_to "/opps" , :alert => "Sorry, resource is not part of your group"
    end
  end
  
  def is_my_group?(group_id)
    return session[:group_id] == group_id
  end
  
  def is_root_domain?
    # return true if there is no subdomain
    result = (request.subdomains.first.present? && request.subdomains.first != "www") ? false : true
  end

  def current_group
    # If subdomain is present, returns the group, else nil
    if !is_root_domain?
      @current_group = Group.find_by_subdomain(request.subdomains.first)
      if @current_group.nil?
        redirect_to opps_url(:group => false, :alert => "Unknown Group/subdomain")
      end
    else 
      @current_group = nil
    end
    @current_group
  end      
  
end
