require 'rails_helper'

RSpec.describe "events/index", type: :view do
  before(:each) do
    assign(:events, [
      Event.create!(
        :title => "Event 1",
        :description => "An Event",
        :location => "New York City",
        :date => DateTime.civil_from_format(:local, 2012)
      ),
      Event.create!(
        :title => "Event 2",
        :description => "An Event",
        :location => "New York City",
        :date => DateTime.civil_from_format(:local, 2012)
      )
    ])
  end

  it "renders a list of events" do
    render
    assert_select "tr>td", :text => "Event 1".to_s, :count => 1
    assert_select "tr>td", :text => "Event 2".to_s, :count => 1
    assert_select "tr>td", :text => "An Event".to_s, :count => 2
    assert_select "tr>td", :text => "New York City".to_s, :count => 2
  end
end
