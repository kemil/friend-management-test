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

end
