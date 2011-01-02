class OverlaysController < ApplicationController

  def index
    @overlays = Overlay.where(:typeof => "transport")
    respond_to do |format|
      format.xml  { render :xml => @overlays }
      format.json  { render :json => @overlays }
    end

  end
  def show

    respond_to do |format|
      format.html
      format.xml  { render :xml => @overlays }
      format.json  { render :json => @overlays }
    end

  end
end
