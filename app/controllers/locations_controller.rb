class LocationsController < ApplicationController
  before_filter :setsession

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
    logger.debug @googleapi
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @locations }
    end
  end
  def findlocations
    # passed parameters are distance => the distance from the point of interest
    # e.g. this could be the lat long of an event location
    # this method assumes meters e.g. 0.5 will be 500 meters
    # the latitude and longitude of the point of interest
    # the service we are interested in :value e.g. eating, atm, pub
    # the sql statement uses the lat and long on the database file to compare
    # with the lat long of the point of interest
    @distance = params[:distance]
    @lon = params[:lon]
    @lat = params[:lat]
    # 6371 is the radius of the earth in kms

    @distcalc = "( 6371 * ACOS( COS( RADIANS(#{@lat}) ) * COS( RADIANS( geo_lat ) ) * COS( RADIANS( geo_long ) - RADIANS(#{@lon}) ) + SIN( RADIANS(#{@lat}) ) * SIN( RADIANS( geo_lat ) ) ) ) "
    @grouping = "GROUP BY id,location_name,geo_long,geo_lat"
    @sql = "SELECT *," + @distcalc + " AS distance FROM locations " + @grouping + " HAVING " + @distcalc + " < #{@distance}  "
    begin
       @eventlocations = Location.find_by_sql(@sql)
    rescue => e
      redirect_to(error_path, :notice => "Error: #{e.message}")
    end
        # clean data
    @eventlocations.each do
     |ol |
     ol.location_name = ol.location_name.gsub("&apos;","'")
     ol.location_name = ol.location_name.gsub("&amp;","&")
    end

    respond_to do |format|
       format.xml  { render :xml => @eventlocations }
       format.json  { render :json => @eventlocations }
    end

  end

end
