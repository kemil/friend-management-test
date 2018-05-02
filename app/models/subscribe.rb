class Subscribe < ApplicationRecord

  validates_uniqueness_of :user_id, :scope => :subscriber_id, message: "Already subscribed"
  validates :subscriber_id, presence: true

  belongs_to :user
  belongs_to :subscriber, :class_name => 'User'

  def self.add(requestor, target)
    users = []
    [requestor, target].each do |email|
      begin
        users << User.find_or_create_by!(email: email)
      rescue => e
        return {message: e.to_s, success: false}
      end
    end

    Subscribe.create_(users)
    return {success: true}
  end

  def self.create_(users)
    unless users.last.has_subscriber?(users.first)
      users.last.subscribes.create!(subscriber_id: users.first.id)
    end
  end

  def self.creates_(users)
    users.first.subscribes.create(subscriber_id: users.last.id)
    users.last.subscribes.create(subscriber_id: users.first.id)
  end

end
