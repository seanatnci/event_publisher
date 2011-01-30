class LocationsController < ApplicationController
  def new
    @location = Location.new()
    if signed_in?
      @organizer = Organizer.find_by_user(current_user.account)
    end
  end
def create
    @location = Location.new(params[:location])
    if signed_in?
      @organizer = Organizer.find_by_user(current_user.account)
    end
       respond_to do |format|
      if @location.save
        format.html { 
          if !signed_in?
            redirect_to(@location, :notice => 'Location was successfully created.')
          else
            redirect_to(new_event_path, :notice => 'Location was successfully created.')
          end
            }
        format.xml  { render :xml => @location, :status => :created, :location => @location }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end
  def show
    @location = Location.find(params[:id])
  end

  def edit
  end

 def index
    @locations = Location.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @locations }
    end
  end

end
