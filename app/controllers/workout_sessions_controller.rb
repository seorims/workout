class WorkoutSessionsController < ApplicationController
  def index
    @workout_sessions = WorkoutSession.includes(:user)
  end
end
