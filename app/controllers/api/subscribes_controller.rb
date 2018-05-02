class Api::SubscribesController < Api::ApiController

  api :post, '/subscribes', 'Subscribe an email'
  param :requestor, String, required: true, desc: 'Subscriber email'
  param :target, String, required: true, desc: 'Subscribe email'
  def create
    subscribe = Subscribe.add(params[:requestor], params[:target])
    render json: subscribe
  end

end
