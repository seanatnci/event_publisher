class EventsController < ApplicationController
  before_filter :authenticate, :only => [:new, :create, :destroy, :edit, :index]

  class StoreSelection
    attr_accessor :date, :category
    include Singleton
  end

  class FullCalander
    attr_accessor :id, :start, :end, :allDay, :url, :title
  end
  
  def new
    @event = Event.new()
    @locations = Location.all
    @costs = ["Free","Paid"]
    @hours = ["7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
    @mins = ["00","15","30","45"]
    @categories = Category.all
    @signed_in_user = current_user
    @organizer = Organizer.find_by_user(@signed_in_user.account)
    @event.organizer = @organizer
    @event.location_id = @organizer.primary_event_location
    @event.event_url = @organizer.event_home_page
  end

  def create
    @organizer = Organizer.find_by_user(current_user.account)
    @event = Event.setnew(params[:event],@organizer)
    @send_tweet = params[:twitter][:tweet]
    
    @locations = Location.all
    @costs = ["Free","Paid"]
    @hours = ["7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
    @mins = ["00","15","30","45"]
    @categories = Category.all
    
      respond_to do |format|
        if @event.save
         format.html {
          TwitterSend.new(@event) if @send_tweet == 'yes' ## maybe should be singleton ?? only if same handle
          @organizer.emails.each do
            | em |
              UserMailer.event_email(@event,em.email).deliver
          end
          redirect_to(@event, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :event => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @event = Event.find(params[:id])
    if signed_in?
      @organizer = Organizer.find_by_user(current_user.account)
    end
    respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @event.to_xml( :skip_instruct => true, :except => [:id,:featured,:organizer_id,:location_id,:category_id,:updated],:include => :location )
     }
      format.json  { render :json => @event.to_json( :skip_instruct => true, :except => [:id,:featured,:organizer_id,:location_id,:category_id,:updated],:include => :location )
     }
    end
        
  end
  
  def detail
    @event = Event.find(params[:id])
  end
  
  def index
    @organizer = Organizer.find_by_user(current_user.account)
    @events = Event.find(:all, :conditions => "organizer_id = #{@organizer.id}")
   
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
      format.json  { render :json => @events }
    end
  end

def selectevents
    @date = Date.today
    begin
      @events = Event.find(:all, :conditions => "date >= '#{@date}'" , :order => 'date' )
    rescue => e
      redirect_to(error_path, :notice => "Error: #{e.message}")
    end
    @dateselect = ["Week","1 Month","2 Months"]
    @categories = Category.all
    @store = StoreSelection.instance
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events.to_xml( :skip_instruct => true, :except => [:id,:featured,:organizer_id,:location_id,:category_id,:updated],:include => :location )
     }
      format.json  { render :json => @events.to_json( :skip_instruct => true, :except => [:id,:featured,:organizer_id,:location_id,:category_id,:updated],:include => :location )
     }
    end
  end

  def viewevents
    @date = Date.today
    @date = @date.strftime('%Y-%m-%d %H:%M:%S')
    @selectDate = Date.today.to_time.advance( :weeks => 1) 
#    @selectDate = Date.today.to_time.advance( :weeks => 1) if params[:store][:date] =="Week"
#    @selectDate = Date.today.to_time.advance( :months => 1) if params[:store][:date] =="1 Month"
#    @selectDate = Date.today.to_time.advance( :months => 2) if params[:store][:date] =="2 Months"
#    @selectDate = @selectDate.to_date
#    @selectDate = @selectDate.strftime('%Y-%m-%d %H:%M:%S')
    @events=Event.find(:all, :conditions => "date >= '#{@date}' and date <= '#{@selectDate}'" , :order => 'date')
    @dateselect = ["Week","1 Month","2 Months"]
    @categories = Category.all
    @store = StoreSelection.instance

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
      format.json  { render :json => @events }
    end
  end

  def calanderevents
    @date = Date.today
    @date = @date.strftime('%Y-%m-%d %H:%M:%S')
    @selectDate = Date.today.to_time.advance( :weeks => 1)
    @events=Event.find(:all, :conditions => "date >= '#{@date}'", :order => 'date')
#    @events=Event.find(:all, :conditions => "date >= '#{@date}' and date <= '#{@selectDate}'" , :order => 'date')
    @calevents = []
    @events.each do | event |
      calevent = FullCalander.new()
      calevent.id = event.id
      calevent.title = event.title
      calevent.start = event.date.strftime('%Y-%m-%d %H:%M:%S')
      calevent.end = event.end_date.strftime('%Y-%m-%d %H:%M:%S')
      calevent.url = event.event_url
      calevent.allDay = false
      @calevents << calevent
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @calevents }
      format.json  { render :json => @calevents }
    end
  end

  def edit
    @event = Event.find(params[:id])
    @organizer = Organizer.find(@event.organizer_id) ## raise exception if signed in not organizer
    @locations = Location.all
    @costs = ["Free","Paid"]
    @categories = Category.all
  end

  def update
    @event = Event.find(params[:id])

    params[:event][:date]=DateTime.strptime(params[:event][:date],"%d/%m/%Y") if params[:event][:date].length == 10
    params[:event][:end_date]=DateTime.strptime(params[:event][:end_date],"%d/%m/%Y") if params[:event][:end_date].length == 10

    @organizer = Organizer.find(@event.organizer_id)
    @locations = Location.all
    @costs = ["Free","Paid"]
    @categories = Category.all
    if @event.update_attributes(params[:event])
      flash[:success] = "Event updated."
      redirect_to events_path
    else
      @title = "Edit Event"
      render 'edit'
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end

  private

    def authenticate
      deny_access unless signed_in?
    end
end
