class Api::SubscribesController < Api::ApiController

  api :post, '/subscribes', 'Subscribe to updates from an email address'
  param :requestor, String, required: true, desc: 'Subscriber email'
  param :target, String, required: true, desc: 'Subscribe email'
  def create
    subscribe = Subscribe.add(params[:requestor], params[:target])
    render json: subscribe
  end

  api :post, '/subscribes/block', 'Block updates from an email address'
  param :requestor, String, required: true, desc: 'Subscribe email'
  param :target, String, required: true, desc: 'Subscriber email'
  def block
    block = Subscribe.block(params[:requestor], params[:target])
    render json: block
  end

  api :post, '/subscribes/unblock', 'Unblock updates from an email address'
  param :requestor, String, required: true, desc: 'Subscribe email'
  param :target, String, required: true, desc: 'Subscriber email'
  def unblock
    unblock = Subscribe.unblock(params[:requestor], params[:target])
    render json: unblock
  end
end
