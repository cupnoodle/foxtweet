class UsersController < ApplicationController

  layout "ft"

  before_action :confirm_logged_in, :except =>[:login, :attempt_login, :new, :create, :logout]

  def index
    
  end

  def show
    username = params[:username]
    #take the first result where username = username
    @user = User.find_by(:username => username)
    @myself = User.find(session[:user_id])
    if @user
      @tweets = @user.tweets.latest.limit(10)
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = 'User created.'
      redirect_to(:action => 'login')
    else
      render("new")
    end
  end

  def edit
    @user = User.find(session[:user_id])
  end

  def update
    @user = User.find(session[:user_id])
    #prevent user update their username and email
    params[:user].delete(:username)
    params[:user].delete(:email)

    if @user.update_attributes(user_params)
      flash[:notice] = 'Profile updated'
      if params[:user][:password].present?
        flash[:notice] += '<br>' + ' Password changed'
      end
      redirect_to(:action => 'edit')
    else
      render('edit')
    end

  end

  def delete
  end

  def destroy
  end

  def login
  end

  def attempt_login
    if params[:username].present? && params[:password].present?
      found_user = User.where(:username => params[:username]).first
      if found_user
        #returns user object if authenticated, else return false
        authorized_user = found_user.authenticate(params[:password])
      end
    end

    if authorized_user
      # mark user as logged in
      session[:user_id] = authorized_user.id
      session[:username] = authorized_user.username
      redirect_to(:controller => 'tweets', :action => 'index')
    else
      flash[:notice] = "Invalid username/password combination."
      redirect_to(:action => 'login')
    end
  end

  def logout
    # mark user as logged out
    session[:user_id] = nil
    session[:username] = nil
    flash[:notice] = "Logged out"
    redirect_to(:action => "login")
  end

  def follow
    @myself = User.find(session[:user_id])
    @user = User.find_by(:username => params[:username])
    @relationship = Relationship.find_by(:follower => @myself, :followed => @user)
    #relationship does not exist , i.e. not yet follow
    #if the followed user exist, that is
    #can't follow ownself of course
    if @user && @myself.username != @user.username
      if !@relationship
        Relationship.create(:follower => @myself, :followed => @user)
      else
        @relationship.destroy
      end
    end

    redirect_to(:back)
  end

  def search
    if params[:term].blank?
      flash[:notice] = "No search term entered"
    else
      @term = params[:term]
      @myself = User.find(session[:user_id])
      @matches = User.where("username LIKE ? OR name LIKE ? ", "%#{params[:term]}%" , "%#{params[:term]}%").limit(15)
    end
  end

  def follower
    @user = User.find_by(:username => params[:username])
    if @user == nil
      flash[:notice] = 'User not found'
      redirect_to(:controller => 'tweets', :action => 'index')
      return
    end

    @myself = User.find(session[:user_id])
    @followers = @user.followers
  end

  def following
    @user = User.find_by(:username => params[:username])
    if @user == nil
      flash[:notice] = 'User not found'
      redirect_to(:controller => 'tweets', :action => 'index')
      return
    end

    @myself = User.find(session[:user_id])
    @followeds = @user.followeds  
  end

  private

  def user_params
    params.require(:user).permit(:username, :name, :email, :description, :password, :password_confirmation, :avatar_url)
  end

end
