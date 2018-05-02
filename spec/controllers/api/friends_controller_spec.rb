require 'rails_helper'

RSpec.describe Api::FriendsController, type: :controller do

  describe 'POST /api/friends' do
    let(:valid_attributes) { { friends: ['email1@spec.com', 'email2@spec.com']} }
    let(:invalid_attributes) { { friends: ['email1@spec.com', 'email2spec.com']} }
    let(:wrong_input_attributes) { { friends: ['email1@spec.com']} }

    context 'when request attributes are valid' do
      it 'returns success' do
        post "create", params: valid_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true}.to_json)

        post "create", params: valid_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({message: "Emails already connected", success: false}.to_json)
      end
    end

    context 'when request attributes are invalid' do
      it 'returns invalid email' do
        post "create", params: invalid_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({message: "Validation failed: Email is invalid", success: false}.to_json)
      end
    end

    context 'when request attributes are wrong' do
      it 'returns invalid input array' do
        post "create", params: wrong_input_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({message: "2 email addresses required", success: false}.to_json)
      end
    end
  end
end
