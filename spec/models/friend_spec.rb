require 'rails_helper'

RSpec.describe Friend, type: :model do
  it { should validate_presence_of(:friend_id) }

  it 'should create friendship between two users' do
    a = "email1@spec.com"
    b = "email2@spec.com"
    c = "email3@spec.com"
    d = "failedemail.com"

    connect = Friend.connect([a, b])
    expect(connect).to eql({success: true})

    connect = Friend.connect([a, b, c])
    expect(connect).to eql({message: "2 email addresses required", success: false})

    connect = Friend.connect([a, d])
    expect(connect).to eql({message: "Validation failed: Email is invalid", success: false})

    connect = Friend.connect([a, b])
    expect(connect).to eql({message: "Emails already connected", success: false})
  end

  it "should show list of user's friends" do
    a = "email1@spec.com"
    b = "email2@spec.com"
    c = "email3@spec.com"
    d = "another@email.com"

    Friend.connect([a, b])
    Friend.connect([a, c])

    friends = Friend.list(a)
    expect(friends).to eql({friends: [b, c], success: true, count: 2})

    friends = Friend.list(d)
    expect(friends).to eql({message: "#{d} is not exist", success: false})
  end

end
