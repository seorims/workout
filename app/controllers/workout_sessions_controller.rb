class WorkoutSessionsController < ApplicationController
  before_action :set_workout_session, only: [:show]
  skip_before_action :authenticate_user!, only: [:index, :show]

  # Displays a single workout session
  def show
    # @workout_session is already set by the before_action
  end

  def index
    @workout_sessions = WorkoutSession.all

    # add dummy placeholder sessions if none exist
    if @workout_sessions.empty?
      @workout_sessions = Array.new(3) do |i|
        WorkoutSession.new(
          title: "Session #{i + 1}",
          location: "Placeholder Location",
          duration: 60,
          price: 20.0,
          desc: "This is a placeholder description for styling purposes.",
          user_id: nil # No associated trainer
        )
      end
    end
  end

  private

  # Finds the workout session by ID
  def set_workout_session
    @workout_session = WorkoutSession.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to workout_sessions_path, alert: "Workout session not found."
  end
end
