require 'rails_helper'

RSpec.describe Event, type: :model do
  let!(:event1) { Event.create(title: 'Event', description: 'An event', location: 'New York', date: DateTime.civil_from_format(:local, 2012)) }
  let!(:user1) { User.create(first_name: 'John', last_name: 'Doe', email: 'john.doe@test.com') }
  let!(:user2) { User.create(first_name: 'Jane', last_name: 'Doe', email: 'jane.doe@test.com') }
  let!(:events_user1) { EventsUser.create(event: event1, user: user1) }
  let!(:events_user2) { event1.events_users.create(user: user2) }

  describe '#events_users' do
    it 'has many events_users' do
      expect(event1.events_users.size).to eq(2)
    end

    it 'deletes associated events_users on destroy' do
      expect { event1.destroy }.to change(EventsUser, :count).by(-2)
    end
  end

  describe '#attendees' do
    it 'has many attendees through events_users' do
      expect(event1.attendees.size).to eq(2)
    end
  end

  describe 'validations' do
    it 'is not valid without a title' do
      event = Event.new
      event.valid?
      expect(event.errors.messages[:title]).to include("can't be blank")
    end

    it 'is not valid without a description' do
      event = Event.new
      event.valid?
      expect(event.errors.messages[:description]).to include("can't be blank")
    end

    it 'is not valid without a location' do
      event = Event.new
      event.valid?
      expect(event.errors.messages[:location]).to include("can't be blank")
    end

    it 'is not valid without a date' do
      event = Event.new
      event.valid?
      expect(event.errors.messages[:date]).to include("can't be blank")
    end

    it 'is not valid with a duplicate title' do
      event = Event.new(title: 'Event')
      event.valid?
      expect(event.errors.messages[:title]).to include('has already been taken')
    end
  end
end
