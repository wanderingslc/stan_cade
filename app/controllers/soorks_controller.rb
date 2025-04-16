class SoorksController < ApplicationController 
  def index 
    @soorks = Soork.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @soorks }
    end
  end
end
