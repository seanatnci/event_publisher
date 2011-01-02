class EmailsController < ApplicationController
  def index
    @emails = Email.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @emails }
    end
  end
  
  def emaillist
     
  end

  def csvup
     require 'csv'
     @organizer = Organizer.find(params[:organizer_id])
     @parsed_file=CSV::Reader.parse(params[:dump][:file])
     n=0
     @parsed_file.each  do |row|
       e=Email.new()
       e.email=row[2]
       e.first_name=row[0]
       e.last_name=row[1]
       e.organizer_id = @organizer.id
       if e.save
        n=n+1
       end
     end
     flash.now[:message]="CSV Import Successful,  #{n} new records added to data base"
     redirect_to( :action => "index", :notice => 'Email file successfully uploaded.')
  end

  def show
  end

  def edit
  end

  def new
    @emailc = Email.new()
    @organizer = Organizer.find(params[:organizer_id])
    @emailc.organizer_id = @organizer.id
  end

  def create
    @emailc = Email.new(params[:email])

       respond_to do |format|
      if @emailc.save
        format.html {
          redirect_to( :action => "index", :notice => 'Email was successfully created.') }
        format.xml  { render :xml => @emailc, :status => :created, :emailc => @emailc }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @emailc.errors, :status => :unprocessable_entity }
      end
    end
  end

end
