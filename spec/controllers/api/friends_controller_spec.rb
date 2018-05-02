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


  describe 'GET /api/friends' do
    let(:valid_attribute) { { email: 'email1@spec.com'} }

    before {
      Friend.connect(['email1@spec.com', 'email2@spec.com'])
      Friend.connect(['email1@spec.com', 'email3@spec.com'])
    }

    context 'when request attributes are valid' do
      it 'returns success' do
        get "index", params: valid_attribute
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true, friends: ['email2@spec.com', 'email3@spec.com'], count: 2}.to_json)
      end

      it 'returns empty friends list' do
        get "index", params: {email: 'emaila@spec.com'}
        expect(response).to have_http_status(200)
        expect(response.body).to eq({message: "emaila@spec.com is not exist", success: false}.to_json)
      end
    end
  end


  describe 'POST /api/friends/common' do
    before {
      Friend.connect(['emaila@spec.com', 'emailb@spec.com'])
      Friend.connect(['emaila@spec.com', 'emailc@spec.com'])
      Friend.connect(['emaila@spec.com', 'emaild@spec.com'])
      Friend.connect(['emaild@spec.com', 'emailb@spec.com'])
    }

    context 'when request by 2 emails' do
      it 'returns success' do
        post "common", params: {friends: ['emaila@spec.com', 'emailb@spec.com']}
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true, friends: ['emaild@spec.com'], count: 1}.to_json)
      end

      it 'returns empty common friends' do
        post "common", params: {friends: ['emaila@spec.com', 'emailc@spec.com']}
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true, friends: [], count: 0}.to_json)
      end

      it 'returns invalid input array' do
        post "common", params: {friends: ['emaila@spec.com', 'emailcspec.com']}
        expect(response).to have_http_status(200)
        expect(response.body).to eq({message: "Validation failed: Email is invalid", success: false}.to_json)
      end
    end
end
end
