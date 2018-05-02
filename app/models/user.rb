class User < ApplicationRecord

  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  has_many :friends
  has_many :friendships, :through => :friends

  has_many :inverse_friendships, :class_name => "Friend", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  has_many :subscribes
  has_many :subscribers, :through => :subscribes

  has_many :inverse_subscribes, :class_name => "Subscribe", :foreign_key => "subscriber_id"
  has_many :inverse_subscribers, :through => :inverse_subscribes, :source => :user

  def self.has_friend?(users)
    a = users.first
    b = users.last
    a.is_connected?(b)
  end

  def is_connected?(target)
    friendships.include?(target)
  end

  def self.create_friendship(users)
    users.first.friends.create(friend_id: users.last.id)
    users.last.friends.create(friend_id: users.first.id)
    Subscribe.creates_(users)
  end

  def has_subscriber?(user)
    self.subscribers.include?(user)
  end

end
