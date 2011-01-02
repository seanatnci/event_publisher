class EventsController < ApplicationController
  def new
    @event = Event.new()
    @locations = Location.all
    @costs = ["Free","Paid"]
    @categories = Category.all
    @organizer = Organizer.find(1)
    @event.organizer_id = @organizer.id
  end

  def create
    @event = Event.new(params[:event])
    
    @locations = Location.all
    @costs = ["Free","Paid"]
    @categories = Category.all
    
       respond_to do |format|
      if @event.save
        format.html { 
          twit = TwitterSend.new()
          handle = @event.organizer.twitter_handle
          message = @event.title + " at " + @event.location.location_name + " on " + @event.date.strftime("%d/%m/%Y")
          handle = "seantwitter"
          twit.with_message(handle,message)
          redirect_to(@event, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :event => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
  end

  def index
    @events = Event.all
   
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
      format.json  { render :json => @events }
    end
  end


  def edit
  end

  def destroy
  end
end
