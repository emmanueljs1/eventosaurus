class User < ApplicationRecord
  include BCrypt

  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email
  validate :first_name_must_be_capitalized
  validate :last_name_must_be_capitalized
  validate :email_must_have_at_and_dot

  has_many :events_users, dependent: :destroy
  has_many :events, through: :events_users, source: :event

  def events_hosting
    created = []
    events.each do |event|
      created << event if event.creator == self
    end
    created
  end

  def events_attending
    attending = []
    events.each do |event|
      attending << event if event.creator != self
    end
    attending
  end

  def first_name_must_be_capitalized
    errors.add(:first_name, 'must be capitalized') if first_name && first_name[0, 1] != first_name[0, 1].upcase
  end

  def last_name_must_be_capitalized
    errors.add(:last_name, 'must be capitalized') if last_name && last_name[0, 1] != last_name[0, 1].upcase
  end

  def email_must_have_at_and_dot
    errors.add(:email, "must have an '@' and a '.'") if email && (!email.include?('@') || !email.include?('.'))
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def password
    @password ||= Password.new(password_hash) unless password_hash.nil?
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
