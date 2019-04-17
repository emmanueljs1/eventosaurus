require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @event = assign(:event, Event.create!(
      :title => "Event",
      :description => "An Event",
      :location => "New York City",
      :date => DateTime.civil_from_format(:local, 2012)
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Event/)
    expect(rendered).to match(/An Event/)
    expect(rendered).to match(/New York City/)
  end
end
