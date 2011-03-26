class UsersController < ApplicationController
  
  before_filter :authenticate, :only => [ :index, :edit, :update, :destroy ]
  before_filter :correct_user, :only => [ :edit, :update ]
  before_filter :admin_user,   :only => :destroy
  
  def index
  	@users = User.paginate(:page => params[:page], :per_page => 25)
  	@title = "All users"
  end
	
  def show
  	@user = User.find(params[:id])
  	@microposts = @user.microposts.paginate(:page => params[:page], :per_page => 15)
  	@title = @user.name
  end
  
  def new
  	@user  = User.new
  	@title = "Sign up"
  end
  
  def create
  	@user = User.new(params[:user])
  	if @user.save
  		sign_in @user
  		redirect_to @user, :flash => { :success => "Welcome to the Sample App!" }
  	else 
  		@title = "Sign up"
  	  render 'new'
  	end
  end
  
  def edit
  	@title = "Edit user"
  end
  
  def update
  	if @user.update_attributes(params[:user])
  		redirect_to @user, :flash => { :success => "Profile updated." }
  	else
  	  @title = "Edit user"
  	  render 'edit'
  	end
  end
  
  def destroy
  	@user.destroy
  	redirect_to users_path, :flash => { :success => "user destroyed." } 
  end
  
  private
  
  	def authenticate
  		deny_access unless signed_in?
  	end
  	
  	def correct_user
  		@user = User.find(params[:id])
  		redirect_to(root_path) unless current_user?(@user)
  	end
  	
  	def admin_user
  		@user = User.find(params[:id])
		redirect_to(root_path) if !current_user.admin? || current_user?(@user)
  	end

end
