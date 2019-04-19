require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  let(:valid_attributes) {
    { :first_name => "John", :last_name => "Doe", :email => "john.doe@test.com", :password => "password" }
  }

  describe "POST #create" do
    context "with valid params" do
      let (:valid_login_params) {
        { :email => "john.doe@test.com", :password => "password" }
      }

      it "logs the user in" do
        user = User.create! valid_attributes
        post :create, params: valid_login_params, session: {}
        expect(session[:user_id]).to be(user.id)
      end

      it "redirects to root" do
        user = User.create! valid_attributes
        post :create, params: valid_login_params, session: {}
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid params" do
      let (:invalid_login_params) {
        { :email => "john.doe@test.com", :password => "not_password" }
      }

      it "redirects to login" do
        user = User.create! valid_attributes
        post :create, params: invalid_login_params, session: {}
        expect(response).to redirect_to(login_path)
      end
    end
  end

end
