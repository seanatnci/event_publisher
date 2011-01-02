class OrganizersController < ApplicationController
  def new
    @organizer = Organizer.new()
    @locations = Location.all
    @organizer.twitter_handle = "businesseventsdublin"
  end

  def create
    @organizer = Organizer.new(params[:organizer])
    @locations = Location.all
    respond_to do |format|
      if @organizer.save
        format.html {
          redirect_to(@organizer, :notice => 'New Organizer successfully created.') }
        format.xml  { render :xml => @organizer, :status => :created, :organizer => @organizer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organizer.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
  end

end
