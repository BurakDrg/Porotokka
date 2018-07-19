require 'sidekiq'

class PostsController < ApplicationController
  include Sidekiq::Worker

  before_action :find_post, only: [:edit, :update, :destroy]
  #before_action :deneme3
  skip_before_action :verify_authenticity_token
  def index
    @post = Post.all
  end

  def new
    @post = Post.new
  end

  def create

    @post = Post.new(post_params)

    if @post.save
      redirect_to @post
    else
      render 'new'
    end
    eventtime = @post.event_time
    time = eventtime[0,2].split(':')[0].to_i

    months = %w[January February March April May June July August September October November December]
    monthdata = @post.event_date.strip.split /\s+/

    counter = 1
    months.each do |monthname|
      break if monthname == monthdata[1]
      counter = counter + 1
    end
    day = monthdata[0].to_i
    mounth = counter
    year = monthdata[2].to_i

    puts counter
  end

  def first(limit = 1)
    if limit == 0
      ''
    elsif limit >= size
      self.dup
    else
      to(limit - 1)
    end
  end

  def show
    @post = Post.find(params[:id])
    NotificationJob.perform_later guest
    #render json: {event_name:@post.event_name, event_date:@post.event_date, event_time:@post.event_time}
  end

  def notification
    fcm_client = FCM.new("AAAAcIjcbiM:APA91bH2h-Y5b20cq72sZPC9rLPvkJMGRFvPDf8ONZzhmeoJj-L7zbhtStJdKVnCeNUB3sqzdiBW6AyRnIwjhAxmOzZ9oO9e-RK1Ym3Tk9LC3oqQYx6UhiaYSlA9Z1ScYNcEfUDtMEbg_E3PnMn9Qe3uoKyua5b-oQ")

     options = {priority: 'high',data: {message: 'message',icon: ''},notification: {body: "message",sound: 'default',icon: ""}}

     user_device_ids=["eWz7xsbHr2Q:APA91bGvP_DaPEUpXdsd3ButywJm8BQE21CNAyPXuaM2sbDBHWRjNr8-z1mXJ0tbdfB2izgf3cOiEp9HyIqKSzKk_WCQXVsKPoaqfqY2DFuXZLj2psXPrCmcAAmAD2mFpptlXn18MKy4HfO_oo93MAGqOZ4xhHAA3Q"]
     response =  fcm_client.send(device_ids, options)

  end

  def edit
    @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to root_path
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to @post
    else
      render 'edit'
    end
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:event_name, :event_date, :event_time)
  end
end
