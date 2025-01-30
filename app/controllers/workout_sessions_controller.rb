class WorkoutSessionsController < ApplicationController
  before_action :set_workout_session, only: [:show]
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :ensure_trainer, only: [:new, :create]

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
          price: 20,
          desc: "This is a placeholder description for styling purposes.",
          user_id: nil # No associated trainer
        )
      end
    end
  end

  def new
    @workout_session = current_user.workout_sessions.build
  end

  def create
    @workout_session = current_user.workout_sessions.build(workout_session_params)
    if @workout_session.save
      redirect_to workout_session_path(@workout_session), notice: 'Session created.'
    else
      render :new
    end
  end

  private

  # Finds the workout session by ID
  def set_workout_session
    @workout_session = WorkoutSession.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to workout_sessions_path, alert: "Workout session not found."
  end

  def workout_session_params
    params.require(:workout_session).permit(:title, :location, :duration, :price, :desc)
  end

  def ensure_trainer
    unless current_user&.role == "Trainer"
      redirect_to root_path, alert: "Only trainers can create sessions"
    end
  end
end
