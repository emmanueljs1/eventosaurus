class UsersController < ApplicationController
  before_action :set_user, except: [:index, :new, :create]
  before_action :authenticate_user, except: [:index, :show, :new, :create]

  Calendar = ::Google::Apis::CalendarV3
  Client = ::Signet::OAuth2::Client

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

  # POST /users/1/gcal
  def add_to_gcal
    service = Calendar::CalendarService.new
    # Use google keys to authorize
    service.authorization = credentials

    # Request for a new access token just in case it expired
    service.authorization.refresh!

    event = Event.find(params[:event_id])

    gcal_event = Google::Apis::CalendarV3::Event.new({
      start: Google::Apis::CalendarV3::EventDateTime.new(date_time: event.date.rfc3339),
      end: Google::Apis::CalendarV3::EventDateTime.new(date_time: (event.date + 1.hours).rfc3339),
      summary: event.title,
      description: event.description,
      location: event.location
    })

    service.insert_event('primary', gcal_event)
    redirect_back fallback_location: @user, notice: "Added #{event.title} to calendar."
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

  def credentials
    Client.new(
      access_token: @user.google_token,
      refresh_token: @user.google_refresh_token,
      client_id: Rails.application.secrets.google_client_id,
      client_secret: Rails.application.secrets.google_client_secret,
      scope: ['userinfo.email', 'userinfo.profile', Calendar::AUTH_CALENDAR_EVENTS],
      redirect_uri: OmniAuth.config.full_host + '/auth/google_oauth2/callback',
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://oauth2.googleapis.com/token'
    )
  end
end
