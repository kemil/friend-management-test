class Friend < ApplicationRecord

  validates_uniqueness_of :user_id, scope: :friend_id
  validates :friend_id, presence: true

  belongs_to :user
  belongs_to :friendship, class_name: 'User', foreign_key: 'friend_id'


  def self.connect(emails)
    return {message: '2 email addresses required', success: false} if emails.blank? || emails.length != 2
    users = []
    emails.each do |email|
      begin
        users << User.find_or_create_by!(email: email)
      rescue => e
        return {message: e.to_s, success: false}
      end
    end

    if User.has_friend?(users)
      return {message: "Emails already connected", success: false}
    else
      User.create_friendship(users)
      return {success: true}
    end
  end

  def self.list(email)
    user = User.find_by_email(email)
    unless user.blank?
      friends = user.friendships.map(&:email)
      count = friends.count
      return {success: true, friends: friends, count: count}
    else
      return {message: "#{email} is not exist", success: false}
    end
  end

end
