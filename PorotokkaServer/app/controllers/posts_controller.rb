class PostsController < ApplicationController
  before_action :find_post, only: [:edit, :update, :destroy]
  after_action :notification, only: [:create]
  skip_before_action :verify_authenticity_token

  def index
    @post = if params[:term]
    Post.where('event_name LIKE ?', "%#{params[:term]}%")
  else
    Post.all
  end
  end

  def all
    @post = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    require 'sidekiq'
    @post = Post.new(post_params)

    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  def show
    @post = Post.find(params[:id])
    #render json: {event_name:@post.event_name, event_date:@post.event_date, event_time:@post.event_time}
  end

  def notification
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
    month = counter
    year = monthdata[2].to_i

    createdDate = @post.created_at.to_s
    difYear =  year - createdDate[0,4].to_i - 1
    difMonth = month - createdDate[5,7].to_i - 1
    difDay = day - createdDate[8,10].to_i - 1
    difHour = createdDate[11,13].to_i + 2
    if difHour > 24
      difHour = time - (difHour - 24)
      difDay = difDay - 1
    else
      difHour = time - difHour
    end
    difMin = 60 - createdDate[14,16].to_i
    waitTime = 0.to_f

    if difYear > 1
      waitTime = difYear.to_f + (difMonth/12).to_f + (difDay/365).to_f + difHour.to_f/(365*24).to_f + (difMin-15).to_f/(365*24*60).to_f
      NotificationWorker.perform_in(waitTime.years,@post.event_name)
      puts "Yıl"
    elsif difMonth > 1
      waitTime = difMonth.to_f + (difDay/30).to_f + difHour.to_f/(30*24).to_f + (difMin-15).to_f/(30*24*60).to_f
      NotificationWorker.perform_in(waitTime.months,@post.event_name)
      puts "Ay"
    elsif difDay > 1
      waitTime = difDay.to_f + (difHour/24).to_f + (difMin-15).to_f/(24*60).to_f
      NotificationWorker.perform_in(waitTime.days,@post.event_name)
      puts "Gün"
    elsif difHour > 1
      waitTime = difHour.to_f + (difMin-15).to_f/(60).to_f
      NotificationWorker.perform_in(waitTime.hours,@post.event_name)
      puts "Saat"
    elsif difMin > 15
      waitTime = difMin-15
      NotificationWorker.perform_in(waitTime.minutes,@post.event_name)
      puts "Dakika"
    else
      NotificationWorker.perform_async(@post.event_name)
      puts "Hemen"
    end
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
    #params.permit(:event_name, :event_date, :event_time)
    params.require(:post).permit(:event_name, :event_date, :event_time)
  end

  def startWorker

  end
end
