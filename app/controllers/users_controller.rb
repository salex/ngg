class UsersController < ApplicationController
  before_filter :login_required, :except => [:new, :create]

  def index
    @users = current_group.users
    authorize! :read, @users
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, :notice => "Thank you for signing up! You are now logged in."
    else
      render :action => 'new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    if params[:user][:sa]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    if @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Your profile has been updated.(U)"
    else
      render :action => 'edit'
    end
  end
  
  def get
    @user = User.find(params[:id])
    authorize! :read, @user
  end
  
  def set
    @user = User.find(params[:id])
    authorize! :read, @user
    if @user.update_attributes(params[:user])
      redirect_to users_path, :notice => "User has been updated"
    else
      render :action => 'get'
    end
  end
  
end
