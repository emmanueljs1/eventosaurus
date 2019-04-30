class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :invite_user]
  before_action :authenticate_user, only: [:new, :create, :edit, :update, :destroy, :invite_user]

  # GET /events
  def index
    @events = Event.all
  end

  # GET /events/1
  def show
    @users = User.all
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    return if @event.creator == current_user

    redirect_back fallback_location: root_path, error: 'You can only edit an event you created.'
  end

  # POST /events
  def create
    @event = Event.new(event_params)
    @event.creator = current_user
    @event.attendees << current_user
    if @event.save
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  def update
    if current_user == @event.creator
      if @event.update(event_params)
        redirect_to @event, notice: 'Event was successfully updated.'
      else
        render :edit
      end
    else
      redirect_to @event, error: 'You can only update an event you created.'
    end
  end

  # DELETE /events/1
  def destroy
    if current_user == @event.creator
      @event.destroy
      redirect_to events_url, notice: 'Event was successfully destroyed.'
    else
      redirect_to @event, notice: 'You can only delete an event you created.'
    end
  end

  # POST events/1/invite
  def invite_user
    inviter = User.find(session[:user_id])
    invitee = User.find(params[:user_id])
    if @event.invite_user(inviter, invitee)
      redirect_back fallback_location: @event, notice: 'User was successfully invited.'
    else
      redirect_back fallback_location: @event, error: 'An error happened while inviting the user'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:title, :description, :location, :date)
  end
end
