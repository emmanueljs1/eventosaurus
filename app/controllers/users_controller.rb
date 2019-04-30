class UsersController < ApplicationController
  before_action :set_user, except: [:index, :new, :create]
  before_action :authenticate_user, except: [:index, :show, :new, :create]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    return if @user == current_user

    redirect_back fallback_location: root_path, error: 'You can only edit your own account.'
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user == current_user
      if @user.update(user_params)
        session[:user_id] = @user.id
        redirect_to @user, notice: "#{@user.full_name} was successfully updated."
      else
        render :edit
      end
    else
      redirect_to @user, error: 'You can only update your own account.'
    end
  end

  # DELETE /users/1
  def destroy
    if @user == current_user
      reset_session
      name = @user.full_name
      @user.destroy
      redirect_to users_url, notice: "#{name} was successfully destroyed."
    else
      redirect_to users_url, error: 'You can only destroy your own account.'
    end
  end

  # POST /users/1/accept_invite
  def accept_invite
    if @user == current_user
      event = Event.find(params[:event_id])
      @user.accept_invite(event)
      redirect_back fallback_location: @user, notice: "Successfully accepted invite to #{event.title}."
    else
      redirect_to users_url, error: 'You can only accept invites you received.'
    end
  end

  # POST /users/1/going
  def mark_going
    event = Event.find(params[:event_id])
    @user.events << event
    redirect_back fallback_location: @user, notice: "Marked going to #{event.title}."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
