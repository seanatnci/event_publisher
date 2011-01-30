class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:account],
                           params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      # Sign the user in and redirect to the user's show page.
        sign_in user
        redirect_to new_organizer_path

    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end



end
