class SessionsController < ApplicationController
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
end
