require 'rails_helper'

RSpec.describe Subscribe, type: :model do
  it { should validate_presence_of(:subscriber_id) }
end
