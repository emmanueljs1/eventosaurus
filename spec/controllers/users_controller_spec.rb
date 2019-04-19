require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:valid_attributes) {
    { :first_name => "John", :last_name => "Doe", :email => "john.doe@test.com", :password => "password" }
  }

  let(:invalid_attributes) {
    { :first_name => "john", :last_name => "doe", :email => "invalid", :password => "password" }
  }

  let(:valid_session) {
    ->(user) {
      { :user_id => user.id } unless user.nil?
    }
  }

  let (:invalid_session) {
    {}
  }

  describe "GET #index" do
    it "returns a success response" do
      user = User.create! valid_attributes
      get :index, params: {}, session: valid_session[user]
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      user = User.create! valid_attributes
      get :show, params: {id: user.to_param}, session: valid_session[user]
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session[nil]
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      user = User.create! valid_attributes
      get :edit, params: {id: user.to_param}, session: valid_session[user]
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new User" do
        expect {
          post :create, params: {user: valid_attributes}, session: valid_session[nil]
        }.to change(User, :count).by(1)
      end

      it "redirects to the created user" do
        post :create, params: {user: valid_attributes}, session: valid_session[nil]
        expect(response).to redirect_to(User.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {user: invalid_attributes}, session: valid_session[nil]
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    let(:new_attributes) {
      { :first_name => "John", :last_name => "Dorian", :email => "john.doe@test.com", :password => "password" }
    }

    context "with valid params and valid session" do
      it "updates the requested user" do
        include BCrypt
        user = User.create! valid_attributes
        put :update, params: {id: user.to_param, user: new_attributes}, session: valid_session[user]
        user.reload
        expect(user.full_name).to eq("John Dorian")
      end

      it "redirects to the user" do
        user = User.create! valid_attributes
        put :update, params: {id: user.to_param, user: valid_attributes}, session: valid_session[user]
        expect(response).to redirect_to(user)
      end
    end

    context "with invalid session" do
      it "does not update the requested user" do
        user = User.create! valid_attributes
        put :update, params: {id: user.to_param, user: new_attributes}, session: invalid_session
        user.reload
        expect(user.full_name).to eq("John Doe")
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        user = User.create! valid_attributes
        put :update, params: {id: user.to_param, user: invalid_attributes}, session: valid_session[user]
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    context "with valid session" do
      it "destroys the requested user" do
        user = User.create! valid_attributes
        expect {
          delete :destroy, params: {id: user.to_param}, session: valid_session[user]
        }.to change(User, :count).by(-1)
      end
    end

    context "with an invalid session" do
      it "does not destroy the requested user" do
        user = User.create! valid_attributes
        expect {
          delete :destroy, params: {id: user.to_param}, session: invalid_session
        }.to change(User, :count).by(0)
      end
    end

    it "redirects to the users list" do
      user = User.create! valid_attributes
      delete :destroy, params: {id: user.to_param}, session: valid_session[user]
      expect(response).to redirect_to(users_url)
    end
  end

end
