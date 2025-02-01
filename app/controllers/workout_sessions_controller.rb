class WorkoutSessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :authenticate_trainer!, only: [:edit, :update, :destroy, :cancel]
  before_action :set_workout_session, only: [:show, :edit, :update, :destroy, :cancel]

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
end
