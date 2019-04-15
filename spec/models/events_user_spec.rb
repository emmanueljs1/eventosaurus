require 'rails_helper'

RSpec.describe EventsUser, type: :model do
  let!(:event) { Event.create(title: 'Event', description: 'An event', location: 'New York', date: DateTime.civil_from_format(:local, 2012)) }
  let!(:user) { User.create(first_name: 'John', last_name: 'Doe') }
  let!(:events_user) { EventsUser.create(event: event, user: user) }

  describe '#user' do
    it 'belongs to a user' do
      expect(events_user.user).to eq(user)
    end
  end

  describe '#event' do
    it 'belongs to an event' do
      expect(events_user.event).to eq(event)
    end
  end
end
