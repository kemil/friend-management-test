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

  api :post, '/friends/common', 'Common friends'
  param :friends, Array, required: true, desc: 'Retrieve the common friends list between two email addresses.'
  def common
    common_friends = Friend.common(params[:friends])
    render json: common_friends
  end
end
