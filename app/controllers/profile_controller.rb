class ProfileController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  authorize_resource class: User
  
  def show
    if profile
      render :show 
    else
      redirect_to root_path, alert: 'Something went wrong - there is no such user' 
    end
  end

  private

  def profile
    User.find_by(id: params[:id])
  end

  helper_method :profile
end
