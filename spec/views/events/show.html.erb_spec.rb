require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @user1 = User.create(first_name: "John", last_name: "Doe", email: "john.doe@test.com", password: "password")
    @user2 = User.create(first_name: "Jane", last_name: "Doe", email: "jane.doe@test.com", password: "password")
    @user3 = User.create(first_name: "Jean", last_name: "Doe", email: "jean.doe@test.com", password: "password")
    @user4 = User.create(first_name: "Jon", last_name: "Doe", email: "jon.doe@test.com", password: "password")
    @users = [@user1, @user2, @user3, @user4]
    assign(:users, @users)
    @event = Event.create(title: "Event", description: "An Event", location: "New York City", date: DateTime.civil_from_format(:local, 2012))
    @event.attendees << @user3 # user3 is event creator
    @event.attendees << @user2 # user2 is going to event
    @event.invite_user(@user2, @user1) # user1 is invited to event
    assign(:event, @event) # user4 is not invited/going to event

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

  it "renders event's attributes" do
    expect(rendered).to have_text(@event.title)
    expect(rendered).to have_text(@event.description)
    expect(rendered).to have_text(@event.location)
    expect(rendered).to have_text("Creator: #{@event.creator.full_name}")
  end

  context "under the event's attendees" do
    it "renders the event's attendees" do
      assert_select "div[id=event-attendees]", 1 do |div|
        @event.attendees.each do |user|
          expect(div).to have_text(user.full_name)
        end
      end
    end

    it "does not render users not attending event" do
      assert_select "div[id=event-attendees]", 1 do |div|
        (@users - @event.attendees).each do |user|
          expect(div).to_not have_text(user.full_name)
        end
      end
    end
  end

  context "under the event's invites" do
    it "renders the event's invitees" do
      assert_select "div[id=event-invitees]", 1 do |div|
        @event.invitees.each do |user|
          expect(div).to have_text(user.full_name)
        end
      end
    end

    it "does not render users not invited to event" do
      assert_select "div[id=event-invitees]", 1 do |div|
        (@users - @event.invitees).each do |user|
          expect(div).to_not have_text(user.full_name)
        end
      end
    end
  end

  context "under the invite user form" do
    it "lets the user invite users not invted/going to the event already" do
      assert_select "div[id=invite-user]", 1 do |div|
        (@users - (@event.invitees + @event.attendees)).each do |user|
          expect(div).to have_text(user.full_name)
        end
      end
    end

    it "does not let the user invite users invted/going to the event already" do
      assert_select "div[id=invite-user]", 1 do |div|
        (@event.invitees + @event.attendees).each do |user|
          expect(div).to_not have_text(user.full_name)
        end
      end
    end
  end
end
