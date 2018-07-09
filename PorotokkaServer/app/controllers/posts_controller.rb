class PostsController < ApplicationController
  before_action :find_post, only: [:edit, :update, :destroy]
  skip_before_action :verify_authenticity_token
  def index
    @post = Post.all
  end

  def open
    render :text => "Server Recieved: #{params[:q]}"
    return
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
  end

  def show
    @post = Post.find(params[:id])

    render json: {event_name:@post.event_name, event_date:@post.event_date, event_time:@post.event_time}
  end

  def edit
  end

  def destroy
    @post.destroy
    redirect_to root_path
  end

  def update
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
    params.permit(:event_name, :event_date, :event_time)
  end
end
