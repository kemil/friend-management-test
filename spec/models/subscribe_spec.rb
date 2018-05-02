require 'rails_helper'

RSpec.describe Subscribe, type: :model do
  it { should validate_presence_of(:subscriber_id) }

  it 'should subscribe an email' do
    a = "emaila@spec.com"
    b = "emailb@spec.com"
    c = "failsedemail.com"
    status = Subscribe.add(a, b)
    expect(status).to eq({success: true})
    user = User.find_by_email(b)
    expect(user.subscribers.count).to eq(1)

    status = Subscribe.add(a, c)
    expect(status).to eq({message: "Validation failed: Email is invalid", success: false})
  end


end
