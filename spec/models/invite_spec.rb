require 'rails_helper'

RSpec.describe Invite, type: :model do
  let!(:event) { Event.create(title: 'Event', description: 'An event', location: 'New York', date: DateTime.civil_from_format(:local, 2012)) }
  let!(:user1) { User.create(first_name: 'John', last_name: 'Doe', email: 'john.doe@test.com') }
  let!(:user2) { User.create(first_name: 'Jane', last_name: 'Doe', email: 'jane.doe@test.com') }

  describe 'validations' do
    it 'is not valid with a user inviting themselves' do
      invite = Invite.new(inviter: user1, invitee: user1, event: event)
      invite.valid?
      expect(invite.errors.messages[:inviter]).to include('cannot invite itself')
    end
  end
end
