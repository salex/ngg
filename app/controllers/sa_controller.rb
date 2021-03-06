class SaController < ApplicationController
  def show
    edit
  end
  
  def edit
    token_type = params[:id][0..1]
    
    case token_type
    when "iv"
      iv
    when "rp"
      rp
    when "rg"
      rg
    else
      render :text => "unknown token #{token_type}"
    end
  end
  
  def iv #invite
    @user = User.find_by_token(params[:id])
    if @user
      
      render :action => "iv"
    else
      redirect_to root_url, :alert => "access token not found or expired"
    end
  end
  
  def rp #reset password
    @user = User.find_by_token(params[:id])
    if @user
      render :action => "rp"
    else
      redirect_to root_url, :alert => "access token not found or expired"
    end
  end
  
  def rg
    @user = User.find_by_token(params[:id])
    if @user
      @user.confirm
      session[:user_id] = @user.id
      session[:user_name] = @user.name
      session[:group_id] = @user.group_id
      render :action => "rg"
    else
      redirect_to root_url, :alert => "access token not found or expired"
    end
  end
  
  def create
    user = User.find_by_email(params[:email])  
    user.send_password_reset if user  
    redirect_to root_url, :notice => "Email sent with password reset instructions."  
  end

  def update
    @user = User.find(params[:id])
    @user.token = nil
    @user.token_expires = nil
    if @user.confirmed_at.nil?
      @user.confirm
    end
    if @user.update_attributes(params[:user])
      redirect_to login_url, :notice => "Your profile has been updated. Please login with updated information"
    else
      params[:id] = params[:user][:token]
      token_type = params[:id][0..1]
      
      render :action => token_type
    end
    
  end
end
