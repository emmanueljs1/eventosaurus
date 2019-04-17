require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        :first_name => "John",
        :last_name => "Doe",
        :email => "john.doe@test.com",
        :password => "password"
      ),
      User.create!(
        :first_name => "Jane",
        :last_name => "Doe",
        :email => "jane.doe@test.com",
        :password => "password"
      )
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", :text => "John Doe".to_s, :count => 1
    assert_select "tr>td", :text => "Jane Doe".to_s, :count => 1
    assert_select "tr>td", :text => "john.doe@test.com".to_s, :count => 1
    assert_select "tr>td", :text => "jane.doe@test.com".to_s, :count => 1
  end
end
