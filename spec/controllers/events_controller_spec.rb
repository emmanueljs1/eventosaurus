require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  let(:valid_attributes) {
    { :title => "Event", :description => "An Event", :location => "New York", :date => DateTime.civil_from_format(:local, 2012) }
  }

  let(:invalid_attributes) {
    { :title => "", :description => "", :location => "", :date => DateTime.civil_from_format(:local, 2012) }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      event = Event.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      event = Event.create! valid_attributes
      get :show, params: {id: event.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      event = Event.create! valid_attributes
      get :edit, params: {id: event.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Event" do
        expect {
          post :create, params: {event: valid_attributes}, session: valid_session
        }.to change(Event, :count).by(1)
      end

      it "redirects to the created event" do
        post :create, params: {event: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Event.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {event: invalid_attributes}, session: valid_session
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
        event = Event.create! valid_attributes
        put :update, params: {id: event.to_param, event: new_attributes}, session: valid_session
        event.reload
        expect(event.location).to eq("New York City")
      end

      it "redirects to the event" do
        event = Event.create! valid_attributes
        put :update, params: {id: event.to_param, event: valid_attributes}, session: valid_session
        expect(response).to redirect_to(event)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        event = Event.create! valid_attributes
        put :update, params: {id: event.to_param, event: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested event" do
      event = Event.create! valid_attributes
      expect {
        delete :destroy, params: {id: event.to_param}, session: valid_session
      }.to change(Event, :count).by(-1)
    end

    it "redirects to the events list" do
      event = Event.create! valid_attributes
      delete :destroy, params: {id: event.to_param}, session: valid_session
      expect(response).to redirect_to(events_url)
    end
  end

end
