class RaceTrackerController < ApplicationController
  def index
    @at_gate = 0
    @in_staging = 1
  end
end
