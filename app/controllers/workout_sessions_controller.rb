class WorkoutSessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_workout_session, only: [:show, :edit, :update, :destroy, :cancel]
  before_action :ensure_trainer, only: [:new, :create, :edit, :update, :destroy, :cancel]


  def index
    @workout_sessions = WorkoutSession.all
  end

  def new
    @workout_session = WorkoutSession.new
end

  def create
    @workout_session = current_user.workout_sessions.new(workout_session_params) # assigned to the logged-in trainer

    if @workout_session.save
      redirect_to @workout_session, notice: "Workout session successfully created."
    else
      Rails.logger.error @workout_session.errors.full_messages.join(", ") # logs errors for debugging
      flash[:alert] = "Failed to create session: #{@workout_session.errors.full_messages.join(", ")}"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Ensure only the trainer who created the session can edit it
    if current_user != @workout_session.trainer
      redirect_to workout_sessions_path, alert: "You are not authorized to edit this session."
    end
  end

  def update
    if current_user != @workout_session.trainer
      redirect_to workout_sessions_path, alert: "You are not authorized to update this session."
      return
    end

    if @workout_session.update(workout_session_params)
      redirect_to @workout_session, notice: "Workout session successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def cancel
    # Only allow the trainer who created the session to cancel it
    if current_user != @workout_session.trainer
      redirect_to workout_sessions_path, alert: "You are not authorized to cancel this session."
      return
    end

    @workout_session.update(status: 'cancelled')
    redirect_to workout_sessions_path, notice: "Session has been cancelled."
  end

  def destroy
    # Ensure only the trainer who created the session can delete it
    if current_user != @workout_session.trainer
      redirect_to workout_sessions_path, alert: "You are not authorized to delete this session."
      return
    end

    @workout_session.destroy
    redirect_to workout_sessions_path, notice: "Workout session successfully deleted."
  end

  private

  def set_workout_session
  @workout_session = WorkoutSession.find_by(id: params[:id])
    unless @workout_session
      redirect_to workout_sessions_path, alert: "Session not found."
    end
  end

  def workout_session_params
    params.require(:workout_session).permit(:title, :duration, :location, :status, :price, :desc)
  end

  def ensure_trainer
    unless current_user&.role == 'trainer'
      redirect_to workout_sessions_path, alert: "Only trainers can perform this action."
    end
  end
end
