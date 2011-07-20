class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      if current_group && (user.group_id == current_group.id)
        session[:user_id] = user.id
        session[:group_id] = user.group_id
        redirect_to_target_or_default root_url, :notice => "Logged in successfully."
      else
        redirect_to auth_url(user.auth_token, :group => user.group.subdomain)
      end
    else
      flash.now[:alert] = "Invalid login or password."
      render :action => 'new'
    end
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => "You have been logged out."
  end
  
  def auth
    user = User.find_by_auth_token(params[:id])
    if user
      session[:user_id] = user.id
      session[:group_id] = user.group_id
      redirect_to_target_or_default root_url, :notice => "Logged in successfully."
    else
      flash.now[:alert] = "Invalid login or password."
      render :action => 'new'
    end
  end
  
  def forgot
    
  end
  
end
