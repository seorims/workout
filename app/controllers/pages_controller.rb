class PagesController < ApplicationController
  # skip authentication for the home action
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @featured_sessions = WorkoutSession.includes(:trainer).limit(9)
  end
end
