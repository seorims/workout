class PagesController < ApplicationController
  def home
    @featured_sessions = WorkoutSession.includes(:trainer).limit(9)
  end
end
