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

  def self.block(requestor, target)
    user_requestor, user_target = Subscribe.determine_user(requestor, target)
    if user_requestor.is_a?(Hash) || user_target.is_a?(Hash)
      return [user_requestor, user_target].flatten.delete_if{|x| x.nil?}.first
    end

    begin
      user_requestor.subscribes.find_by_subscriber_id(user_target.id).update_attribute(:block, true)
    rescue => e
      return {message: 'Target not subscribed', success: false}
    end
    return {success: true}
  end

  def self.unblock(requestor, target)
    user_requestor, user_target = Subscribe.determine_user(requestor, target)
    if user_requestor.is_a?(Hash) || user_target.is_a?(Hash)
      return [user_requestor, user_target].flatten.delete_if{|x| x.nil?}.first
    end

    begin
      user_requestor.subscribes.find_by_subscriber_id(user_target.id).update_attribute(:block, false)
    rescue => e
      return {message: 'Target not blocked', success: false}
    end
    return {success: true}
  end

  def self.determine_user(requestor, target)
    users = []
    [requestor, target].each do |email|
      return {message: "#{email} is invalid email", success: false} unless Subscribe.validate_email(email)
      user = User.find_by(email: email)
      return {message: "This email #{email} is not found", success: false} unless user.present?
      users << user
    end

    return users
  end

  def self.send_update(sender, text)
    return {message: "#{sender} is invalid email", success: false} unless Subscribe.validate_email(sender)
    user = User.find_by_email(sender)
    return {message: "This email #{sender} is not found", success: false} if user.blank?
    Subscribe.find_email_address(user, text)

    friend_ids = user.friendship_ids
    blocked_ids = user.subscribes.where(block: true).map(&:subscriber_id)
    unblocked_ids = user.subscribes.where(block: false).map(&:subscriber_id)
    recepient = (friend_ids + unblocked_ids).select{|x| blocked_ids.exclude?(x)}.uniq || []
    emails = User.find(recepient).map(&:email) || []

    return {success: true, recepient: emails}
  end

  def self.find_email_address(user, text)
    emails = []
    Subscribe.find_email(text).each do |email|
      emails << email
    end
    emails.each do |email|
      requestor = User.find_or_create_by!(email: email)
      Subscribe.creates_([requestor, user])
    end
  end


  def self.validate_email(email)
    return (email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i).present?
  end

  def self.find_email(text)
    text.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i)
  end

end
