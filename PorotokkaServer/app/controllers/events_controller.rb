class EventsController < ApplicationController
  before_action :find_event, only: [:show, :edit, :update, :destroy]
  def index
    @event = Events.all.order("created")
  end

  def show
    @event = Events.find(params[:Event_ID])
  end

  def edit
    @event = Events.find(params[:Event_ID])
  end

  def update
    @event = Events.find(params[:Event_ID])

    if @event.update(event_params)
      redirect_to @event
    else
      render 'edit'
  end

  def destroy
    @event.destroy
    redirect_to root_path
  end

  def create
     @event = Events.new
     if @event.save
       redirect_to @event
     else
       render 'new'
     end
  end

  private

  def find_event
    @event = Events.find(params[:Event_ID])
  end

  def event_params
    params.require(:event).permit(:Event_ID, :Event_Name, :Event_Date, :Event_Time)
  end

end
