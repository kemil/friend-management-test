require 'rails_helper'

RSpec.describe Subscribe, type: :model do
  it { should validate_presence_of(:subscriber_id) }

  it 'should subscribe an email' do
    a = "email-a@spec.com"
    b = "email-b@spec.com"
    c = "failsedemail.com"
    status = Subscribe.add(a, b)
    expect(status).to eq({success: true})
    user = User.find_by_email(b)
    expect(user.subscribers.count).to eq(1)

    status = Subscribe.add(a, c)
    expect(status).to eq({message: "Validation failed: Email is invalid", success: false})
  end

  it "should block and unblock an email from updates" do
    a = "email-a@spec.com"
    b = "email-b@spec.com"
    c = "email-c@spec.com"
    d = "failsedemail.com"

    Subscribe.add(a, b)
    user_a = User.find_by_email(a)
    user_b = User.find_by_email(b)

    status = user_b.subscribes.find_by(subscriber_id: user_a.id).block
    expect(status).to eq(false)

    #block
    Subscribe.block(b, a)
    status = user_b.subscribes.find_by(subscriber_id: user_a.id).block
    expect(status).to eq(true)

    #unblock
    Subscribe.unblock(b, a)
    status = user_b.subscribes.find_by(subscriber_id: user_a.id).block
    expect(status).to eq(false)
  end

  it "should retrieve all email addresses that can receive updates from an email address" do
    a = "email-a@spec.com"
    b = "email-b@spec.com"
    c = "email-c@spec.com"
    d = "email-d@spec.com"
    z = "failedemail.com"

    #failed
    status = Subscribe.send_update(a, "This is send update email")
    expect(status).to eq({message: "This email email-a@spec.com is not found", success: false})

    Friend.connect([a, b])
    Subscribe.add(d, a)

    #retrieve emails
    status = Subscribe.send_update(a, "This is send update email")
    expect(status).to eq(success: true, recepient: [b, d])

    #invalid email
    status = Subscribe.send_update(z, "This is send update email")
    expect(status).to eq(message: "#{z} is invalid email", success: false)

    #invite email mentioned
    status = Subscribe.send_update(b, "These email address: email-d@spec.com will be invited ")
    expect(status).to eq({success: true, recepient: [a, d]})

    #block 1 user
    Subscribe.block(a, b)
    status = Subscribe.send_update(a, "These email addresses: email-d@spec.com email-c@spec.com will be invited ")
    expect(status).to eq({success: true, recepient: [d, c]})

    #unblock 1 user
    Subscribe.unblock(a, b)
    status = Subscribe.send_update(a, "These email addresses: email-d@spec.com email-c@spec.com will be invited ")
    expect(status).to eq({success: true, recepient: [b, d, c]})
  end

end
