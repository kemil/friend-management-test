require 'rails_helper'

RSpec.describe Api::SubscribesController, type: :controller do

  describe 'POST /subscribes' do
    let(:valid_attributes) { { requestor: 'emailA@spec.com', target: 'emailB@spec.com'} }
    let(:invalid_attributes) { { requestor: 'emailA@spec.com', target: 'emailbspec.com'} }
    let(:wrong_input_attributes) { { requestor: 'emailA@spec.com', target: nil} }

    context 'when request attributes are valid' do
      it 'return success' do
        post "create", params: valid_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true}.to_json)
      end
    end

    context 'when request attributes are invalid' do
      it 'return email invalid' do
        post "create", params: invalid_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({message: "Validation failed: Email is invalid", success: false}.to_json)
      end
    end

    context 'when request use wrong parameters' do
      it 'returns validation failed' do
        post "create", params: wrong_input_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({message: "Validation failed: Email can't be blank, Email is invalid", success: false}.to_json)
      end
    end
  end


end
