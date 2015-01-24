class TweetsController < ApplicationController

  layout 'ft'

  before_action :confirm_logged_in, :except => [:show]
  
  def index
    current_user = User.find(session[:user_id])
    followed_users = current_user.followeds.pluck(:id)
    followed_users << current_user.id

    @myself = current_user
    @tweets = Tweet.where(user_id: followed_users).latest.limit(10)

  end

  def show
    flash[:notice] = nil
     @tweet = Tweet.find_by(:id => params[:id])
  end

  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user_id = session[:user_id]
    if @tweet.save
      redirect_to(:action => 'index')
    else
      flash[:notice] = "Tweet creation failed" + " <br> " + @tweet.errors.full_messages.to_s
      redirect_to(:action => 'index')
    end
  end

  def destroy
    @tweet = Tweet.find_by(:id => params[:id])
    if @tweet.user.username == session[:username]
      @tweet.destroy
    else
      flash[:notice] = "Invalid action performed"
    end

    redirect_to(:controller=> 'users', :action => 'show', :username => session[:username])
  end

  private

    def tweet_params
      params.require(:tweet).permit(:content)
    end 
end
