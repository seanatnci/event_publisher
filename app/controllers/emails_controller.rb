class EmailsController < ApplicationController
  before_filter :authenticate
  def index
    @organizer = Organizer.find(params[:organizer_id])
    @emails = Email.find(:all, :conditions => "organizer_id = #{@organizer.id}")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @emails }
    end
  end
  
  def emaillist
       @organizer = Organizer.find(params[:id])
  end

  def csvup
     require 'csv'
     # assumes format last_name,first_name,email_address
     #
     @organizer = Organizer.find(params[:id])
     @parsed_file=CSV.parse(params[:dump][:file])
     n=0
     @parsed_file.each  do |row|
       e=Email.new()
       e.email=row[2]
       e.first_name=row[0]
       e.last_name=row[1]
       e.organizer_id = @organizer.id
       existsalready = Email.first(:conditions => {:email => e.email, :organizer_id => @organizer.id})
       if existsalready.nil?
         if e.save
           n=n+1
         end
       end
     end
     flash[:message]="CSV Import Successful,  #{n} new records added to data base"
     redirect_to organizer_emails_path(@organizer)
  end

  def show
  end

  def edit
     @email = Email.find(params[:id])
     @organizer = Organizer.find(@email.organizer_id)
  end

  def update
    @email = Email.find(params[:id])
    @organizer = Organizer.find(@email.organizer_id)
    if @email.update_attributes(params[:email])
      flash[:success] = "Contact details updated."
      redirect_to organizer_emails_path(@organizer)
    else
      @title = "Edit email contact"
      render 'edit'
    end
  end
  
  def new
    @email = Email.new()
    @organizer = Organizer.find(params[:organizer_id])
    @email.organizer_id = @organizer.id
  end

  def create
    @email = Email.new(params[:email])
    @organizer = Organizer.find(@email.organizer_id)
    respond_to do |format|
      if @email.save
        format.html {
          flash[:message]="new email contact successfully added !"
          redirect_to organizer_emails_path(@organizer) }
        format.xml  { render :xml => @email, :status => :created, :emailc => @email }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @email.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /emails/1
  # DELETE /emails/1.xml
  def destroy
    @email = Email.find(params[:id])
    @organizer = Organizer.find(params[:organizer_id])
    @email.destroy
    
    respond_to do |format|
      format.html {  flash[:message]="email contact successfully deleted !"
                     redirect_to(organizer_emails_path(@organizer)) }
      format.xml  { head :ok }
    end
  end
  
private

    def authenticate
      deny_access unless signed_in?
    end
end
