require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      :first_name => "John",
      :last_name => "Doe",
      :email => "john.doe@test.com",
      :password => "password"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/John Doe/)
    expect(rendered).to match(/john.doe@test.com/)
  end
end
