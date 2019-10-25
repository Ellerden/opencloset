class ClosetsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  #load_and_authorize_resource

  def index
    @closets = Closet.all
  end
end
