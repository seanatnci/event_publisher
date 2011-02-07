class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  before_filter :setsession

  def setsession
    @googleapi = Setting.googleapi
  end
end
