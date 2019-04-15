require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user1) { User.create(first_name: 'User', last_name: 'One', email: 'user1@test.com') }
  let!(:event1) { Event.create(title: 'Event 1', description: 'An event', location: 'New York', date: DateTime.civil_from_format(:local, 2012)) }
  let!(:event2) { Event.create(title: 'Event 2', description: 'An event', location: 'New York', date: DateTime.civil_from_format(:local, 2012)) }
  let!(:events_user1) { EventsUser.create(event: event1, user: user1) }
  let!(:events_user2) { user1.events_users.create(event: event2) }

  describe '#events_users' do
    it 'has many events_users' do
      expect(user1.events_users.size).to eq(2)
    end

    it 'deletes associated events_users on destroy' do
      expect { user1.destroy }.to change(EventsUser, :count).by(-2)
    end
  end

  describe '#events' do
    it 'has many events through events_users' do
      expect(user1.events.size).to eq(2)
    end
  end

  describe 'BCrypt' do
    it 'includes BCrypt' do
      expect(User.ancestors).to include(BCrypt)
    end

    it 'has a #password method' do
      expect(User.public_instance_methods).to include(:password)
    end

    it 'has a #password= method' do
      expect(User.public_instance_methods).to include(:password=)
    end

    it 'does not have a password column' do
      expect(ApplicationRecord.connection.column_exists?(:users, :password)).to be false
    end

    it 'does have a password_hash column' do
      expect(ApplicationRecord.connection.column_exists?(:users, :password_hash)).to be true
    end
  end

  it "returns the user's full name" do
    expect(user1.full_name).to eq("#{user1.first_name} #{user1.last_name}")
  end

  describe 'validations' do
    it 'is not valid without a first_name' do
      user = User.new
      user.valid?
      expect(user.errors.messages[:first_name]).to include("can't be blank")
    end

    it 'is not valid without a last_name' do
      user = User.new
      user.valid?
      expect(user.errors.messages[:last_name]).to include("can't be blank")
    end

    it 'is not valid without an email' do
      user = User.new
      user.valid?
      expect(user.errors.messages[:email]).to include("can't be blank")
    end

    it 'is not valid with a duplicate email' do
      user = User.new(email: 'user1@test.com')
      user.valid?
      expect(user.errors.messages[:email]).to include('has already been taken')
    end

    it 'is not valid with a non-capitalized first_name' do
      user = User.new(first_name: 'user')
      user.valid?
      expect(user.errors.messages[:first_name]).to include('must be capitalized')
    end

    it 'is not valid with a non-capitalized last_name' do
      user = User.new(last_name: 'five')
      user.valid?
      expect(user.errors.messages[:last_name]).to include('must be capitalized')
    end

    it "is not valid if the email does not have an '@'" do
      user = User.new(email: '.')
      user.valid?
      expect(user.errors.messages[:email]).to include("must have an '@' and a '.'")
    end

    it "is not valid if the email does not have a '.'" do
      user = User.new(email: '@')
      user.valid?
      expect(user.errors.messages[:email]).to include("must have an '@' and a '.'")
    end

    it "is not valid if the email does not have an '@' and a '.'" do
      user = User.new(email: 'email')
      user.valid?
      expect(user.errors.messages[:email]).to include("must have an '@' and a '.'")
    end

    it 'is valid with correct data' do
      expect(User.new(first_name: 'User', last_name: 'Five', email: 'user5@test.com').valid?).to be true
    end
  end
end
