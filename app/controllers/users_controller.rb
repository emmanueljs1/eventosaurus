class UsersController < ApplicationController
  before_action :set_user, except: [:index, :new, :create]
  before_action :authenticate_user, except: [:index, :show, :new, :create]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    return if @user == current_user

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, error: 'You can only edit your own account.' }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user == current_user
        if @user.update(user_params)
          session[:user_id] = @user.id
          format.html { redirect_to @user, notice: "#{@user.full_name} was successfully updated." }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @user, error: 'You can only update your own account.' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    respond_to do |format|
      if @user == current_user
        reset_session
        name = @user.full_name
        @user.destroy
        format.html { redirect_to users_url, notice: "#{name} was successfully destroyed." }
        format.json { head :no_content }
      else
        format.html { redirect_to users_url, error: 'You can only destroy your own account.' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /users/1/accept_invite
  # POST /users/1/accept_invite.json
  def accept_invite
    respond_to do |format|
      if @user == current_user
        event = Event.find(params[:event_id])
        @user.accept_invite(event)
        format.html { redirect_back fallback_location: @user, notice: "Successfully accepted invite to #{event.title}." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { redirect_to users_url, error: 'You can only accept invites you received.' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST users/1/going
  # POST /users/1/going.json
  def mark_going
    respond_to do |format|
      event = Event.find(params[:event_id])
      @user.events << event
      format.html { redirect_back fallback_location: @user, notice: "Marked going to #{event.title}." }
    end
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
