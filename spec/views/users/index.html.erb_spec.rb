require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    @user1 = User.create(first_name: "John", last_name: "Doe", email: "john.doe@test.com", password: "password")
    @user2 = User.create(first_name: "Jane", last_name: "Doe", email: "jane.doe@test.com", password: "password")
    @user3 = User.create(first_name: "Jean", last_name: "Doe", email: "jean.doe@test.com", password: "password")
    @users = [@user1, @user2, @user3]
    assign(:users, @users)

    controller.singleton_class.class_eval do
      protected

      helper_method :logged_in?
      helper_method :current_user

      def logged_in?
        true
      end

      # user3
      def current_user
        User.last
      end
    end

    render
  end

  it "renders a list of users" do
    @users.each do |user|
      assert_select "div[id=user_#{user.id}]", 1 do |div|
        expect(div).to have_text(user.full_name)
        expect(div).to have_text(user.email)
      end
    end
  end

  it "lets the user delete their account" do
    assert_select "div[id=user_#{view.current_user.id}]", 1 do |div|
      expect(div).to have_text("Delete account")
    end
  end

  it "lets the user edit their account" do
    assert_select "div[id=user_#{view.current_user.id}]", 1 do |div|
      expect(div).to have_text("Edit account")
    end
  end

  it "does not let the user delete another account" do
    other_users = @users - [view.current_user]
    other_users.each do |user|
      assert_select "div[id=user_#{user.id}]", 1 do |div|
        expect(div).to_not have_text("Delete account")
      end
    end
  end

  it "does not let the user edit another account" do
    other_users = @users - [view.current_user]
    other_users.each do |user|
      assert_select "div[id=user_#{user.id}]", 1 do |div|
        expect(div).to_not have_text("Edit account")
      end
    end
  end

end
