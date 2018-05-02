class Api::FriendsController < Api::ApiController

  api :post, '/friends', 'Create friends'
  param :friends, Array, required: true, desc: '2 email addresses to connect'
  def create
    connect = Friend.connect(params[:friends])
    render json: connect
  end

  api :get, '/friends', 'List of friends'
  param :email, String, required: true, desc: 'Selected user email'
  def index
    friends = Friend.list(params[:email])
    render json: friends
  end
end
