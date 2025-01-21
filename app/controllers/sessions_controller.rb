class WorkoutSessionsController < ApplicationController
  before_action :set_workout_session, only: [:show]

  # Displays all workout sessions
  def index
    @workout_sessions = WorkoutSession.all
  end

  # Displays a single workout session
  def show
    # @workout_session is already set by the before_action
  end

  private

  # Finds the workout session by ID
  def set_workout_session
    @workout_session = WorkoutSession.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to workout_sessions_path, alert: "Workout session not found."
  end
end
