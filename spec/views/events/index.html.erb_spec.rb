require 'rails_helper'

RSpec.describe "events/index", type: :view do
  before(:each) do
    @user1 = User.create(first_name: "John", last_name: "Doe", email: "john.doe@test.com", password: "password")
    @user2 = User.create(first_name: "Jane", last_name: "Doe", email: "jane.doe@test.com", password: "password")
    @event1 = Event.create(title: "Event 1", description: "An Event", location: "New York City", date: DateTime.civil_from_format(:local, 2012))
    @event2 = Event.create(title: "Event 2", description: "An Event", location: "New York City", date: DateTime.civil_from_format(:local, 2012))
    @event1.attendees << @user1 # user1 is event1's creator
    @event2.attendees << @user2 # user2 is event2's creator
    @events = [@event1, @event2]
    assign(:event, @events)

    controller.singleton_class.class_eval do
      protected

      helper_method :logged_in?
      helper_method :current_user

      def logged_in?
        true
      end

      # user2
      def current_user
        User.last
      end
    end

    render
  end

  it "renders a list of events" do
    @events.each do |event|
      assert_select "div[id=event_#{event.id}]", 1 do |div|
        expect(div).to have_text(event.title)
        expect(div).to have_text(event.description)
        expect(div).to have_text(event.location)
        expect(div).to have_text(event.creator.full_name)
      end
    end
  end

  it "lets the event creator delete the event" do
    assert_select "div[id=event_#{@event2.id}]", 1 do |div|
      expect(div).to have_text("Delete event")
    end
  end

  it "lets the event creator edit the event" do
    assert_select "div[id=event_#{@event2.id}]", 1 do |div|
      expect(div).to have_text("Edit event")
    end
  end

  it "does not let a user delete an event they didn't create" do
    assert_select "div[id=event_#{@event1.id}]", 1 do |div|
      expect(div).to_not have_text("Delete event")
    end
  end

  it "does not let a user edit an event they didn't create" do
    assert_select "div[id=event_#{@event1.id}]", 1 do |div|
      expect(div).to_not have_text("Edit event")
    end
  end
end
