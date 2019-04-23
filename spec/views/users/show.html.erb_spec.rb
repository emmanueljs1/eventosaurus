require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user3 = User.create(first_name: "John", last_name: "Doe", email: "john.doe@test.com", password: "password")
    @user2 = User.create(first_name: "Jane", last_name: "Doe", email: "jane.doe@test.com", password: "password")
    @user1 = User.create(first_name: "Jean", last_name: "Doe", email: "jean.doe@test.com", password: "password")
    assign(:user, @user1)

    @event1 = Event.create(title: "Event 1", description: "An Event", location: "New York City", date: DateTime.civil_from_format(:local, 2012))
    @event1.attendees << @user1 # user1 is event1 creator

    @event2 = Event.create(title: "Event 2", description: "An Event", location: "New York City", date: DateTime.civil_from_format(:local, 2012))
    @event2.attendees << @user2
    @event2.attendees << @user1 # user1 is attending event2

    @event3 = Event.create(title: "Event 3", description: "An Event", location: "New York City", date: DateTime.civil_from_format(:local, 2012))
    @event3.attendees << @user3
    @event3.invite_user(@user3, @user1) # user1 is invited to event3

    @events = [@event1, @event2, @event3]

    controller.singleton_class.class_eval do
      protected

      helper_method :logged_in?
      helper_method :current_user

      def logged_in?
        true
      end

      # user1
      def current_user
        User.last
      end
    end

    render
  end

  it "renders event's attributes" do
    expect(rendered).to have_text(@user1.full_name)
    expect(rendered).to have_text(@user1.email)
  end

  context 'under events created' do
    it "renders the user's created events" do
      assert_select "div[id=events-created]", 1 do |div|
        @user1.events_hosting.each do |event|
          expect(div).to have_text(event.title)
        end
      end
    end
  
    it "does not render events the user did not create" do
      assert_select "div[id=events-created]", 1 do |div|
        (@events -  @user1.events_hosting).each do |event|
          expect(div).to_not have_text(event.title)
        end
      end
    end
  end

  context 'under events attending' do
    it "renders the events the user is attending" do
      assert_select "div[id=events-attending]", 1 do |div|
        @user1.events_attending.each do |event|
          expect(div).to have_text(event.title)
        end
      end
    end
  
    it "does not render events the user is not attending" do
      assert_select "div[id=events-attending]", 1 do |div|
        (@events - @user1.events_attending).each do |event|
          expect(div).to_not have_text(event.title)
        end
      end
    end    
  end

  context 'under invites pending' do
    it "renders the pending invites" do
      assert_select "div[id=invites-pending]", 1 do |div|
        @user1.invites_received.each do |invite|
          expect(div).to have_text(invite.event.title)
        end
      end
    end
  end
end
