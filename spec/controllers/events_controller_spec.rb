require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  let(:valid_attributes) {
    { :title => "Event", :description => "An Event", :location => "New York", :date => DateTime.civil_from_format(:local, 2012) }
  }

  let(:invalid_attributes) {
    { :title => "", :description => "", :location => "", :date => DateTime.civil_from_format(:local, 2012) }
  }

  let(:user) {
    User.create(first_name: "John", last_name: "Doe", email: "john.doe@test.com", password: "password")
  }

  let(:valid_session) { 
    ->(user) {
      { :user_id => user.id } unless user.nil?
    }
  }

  describe "GET #index" do
    it "returns a success response" do
      event = Event.create! valid_attributes
      get :index, params: {}, session: valid_session[nil]
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      event = Event.create! valid_attributes
      get :show, params: {id: event.to_param}, session: valid_session[nil]
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session[user]
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      event = Event.create! valid_attributes
      event.attendees << user
      get :edit, params: {id: event.to_param}, session: valid_session[user]
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Event" do
        expect {
          post :create, params: {event: valid_attributes}, session: valid_session[user]
        }.to change(Event, :count).by(1)
      end

      it "redirects to the created event" do
        post :create, params: {event: valid_attributes}, session: valid_session[user]
        expect(response).to redirect_to(Event.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {event: invalid_attributes}, session: valid_session[user]
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { :title => "Event", :description => "An Event", :location => "New York City", :date => DateTime.civil_from_format(:local, 2012) }
      }

      it "updates the requested event" do
        post :create, params: {event: valid_attributes}, session: valid_session[user]
        event = Event.last
        put :update, params: {id: event.to_param, event: new_attributes}, session: valid_session[user]
        event.reload
        expect(Event.last.location).to eq("New York City")
      end

      it "redirects to the event" do
        post :create, params: {event: valid_attributes}, session: valid_session[user]
        event = Event.last
        put :update, params: {id: event.to_param, event: new_attributes}, session: valid_session[user]
        expect(response).to redirect_to(event)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        post :create, params: {event: valid_attributes}, session: valid_session[user]
        event = Event.last
        put :update, params: {id: event.to_param, event: invalid_attributes}, session: valid_session[user]
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested event" do
      post :create, params: {event: valid_attributes}, session: valid_session[user]
      event = Event.last
      expect {
        delete :destroy, params: {id: event.to_param}, session: valid_session[user]
      }.to change(Event, :count).by(-1)
    end

    it "redirects to the events list" do
      post :create, params: {event: valid_attributes}, session: valid_session[user]
      event = Event.last
      delete :destroy, params: {id: event.to_param}, session: valid_session[user]
      expect(response).to redirect_to(events_url)
    end
  end

end
