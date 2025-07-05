class RaceTrackerController < ApplicationController
  def index
    @at_gate = 0
    @in_staging = 1
  end

  def show
    @club = Club.find_by(slug: params[:slug])
    
    if @club.nil?
      redirect_to root_path, alert: "Club not found"
      return
    end

    @at_gate = 0
    @in_staging = 1
  end
end
