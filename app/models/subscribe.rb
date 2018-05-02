class Subscribe < ApplicationRecord

  validates_uniqueness_of :user_id, :scope => :subscriber_id, message: "Already subscribed"
  validates :subscriber_id, presence: true

  belongs_to :user
  belongs_to :subscriber, :class_name => 'User'

end
