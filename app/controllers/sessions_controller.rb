class SessionsController < ApplicationController
  before_action :authenticate_user, only: [:google_auth]

  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:email])

    if user.nil? || user.password != params[:password]
      redirect_to '/login'
    else
      session[:user_id] = user.id
      redirect_to '/'
    end
  end

  def destroy
    reset_session
    redirect_to '/'
  end

  def google_auth
    # Get access tokens from the google server
    access_token = request.env["omniauth.auth"]
    user = current_user
    # Access_token is used to authenticate request made from the rails application to the google server
    user.google_token = access_token.credentials.token
    # Refresh_token to request new access_token
    # Note: Refresh_token is only sent once during the first request
    refresh_token = access_token.credentials.refresh_token
    user.google_refresh_token = refresh_token if refresh_token.present?
    user.save
    redirect_to current_user
  end
end
