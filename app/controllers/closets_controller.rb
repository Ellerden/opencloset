class ClosetsController < ApplicationController
  def index
    @closets = Closet.all
  end
end
