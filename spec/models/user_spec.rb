require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it 'email with invalid format is invalid' do
    user = User.new(email: 'wrongemail')
    user.save
    expect(user.errors.messages[:email]).to eq(['is invalid'])
  end
  it { should have_many(:friendships) }
  it 'should create an email' do
    a = User.find_or_create_by!(email: "email-t@spec.com")
    expect(User.count).to eq(1)
    expect(a.email).to eq("email-t@spec.com")
  end

  it 'should show their friendship status is false' do
    a = User.find_or_create_by!(email: "email-a@spec.com")
    b = User.find_or_create_by!(email: "email-b@spec.com")
    status = User.has_friend?([a, b])
    expect(status).to eq(false)
  end

  it 'should show their friendship status is true' do
    a = User.find_or_create_by!(email: "email-a@spec.com")
    b = User.find_or_create_by!(email: "email-b@spec.com")
    status = User.has_friend?([a, b])
    expect(status).to eq(false)

    connect = User.create_friendship([a, b])
    status = User.has_friend?([a, b])
    expect(status).to eq(true)
  end

  it 'should show their subscribe status is false' do
    a = User.find_or_create_by!(email: "email-a@spec.com")
    b = User.find_or_create_by!(email: "email-b@spec.com")
    status = a.has_subscriber?(b)
    expect(status).to eq(false)
  end

  it 'should show their subscribe status is true' do
    a = User.find_or_create_by!(email: "email-a@spec.com")
    b = User.find_or_create_by!(email: "email-b@spec.com")
    Subscribe.creates_([b, a])
    status = a.has_subscriber?(b)
    expect(status).to eq(true)
  end
end
