class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, only: [:new, :create, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    return if @event.creator == current_user

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, error: 'You can only edit an event you created.' }
      format.json { render json: @event.errors, status: :unprocessable_entity }
    end
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.attendees << current_user
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if current_user == @event.creator
        if @event.update(event_params)
          format.html { redirect_to @event, notice: 'Event was successfully updated.' }
          format.json { render :show, status: :ok, location: @event }
        else
          format.html { render :edit }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @event, error: 'You can only update an event you created.' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    respond_to do |format|
      if current_user == @event.creator
        @event.destroy
        format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      else
        format.html { redirect_to @event, notice: 'You can only delete an event you created.' }
      end
      format.json { head :no_content }
    end
  end

  # POST events/1/invite
  def invite_user
    respond_to do |format|
      if @event.invite_user
        format.html { redirect_back fallback_location: @event, notice: 'User was successfully invited.' }
      else
        format.html { redirect_back fallback_location: @event, error: 'An error happened while inviting the user' }
      end
      format.json { head :no_content }
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
