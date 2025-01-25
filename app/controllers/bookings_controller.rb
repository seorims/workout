class BookingsController < ApplicationController
  before_action :authenticate_user!

  def create
    @workout_session = WorkoutSession.find(params[:workout_session_id])
    @booking = current_user.bookings.new(workout_session: @workout_session, booked_at: Time.now.in_time_zone('Tokyo'))

    if @booking.save
      # Redirect to the bookings page after a successful booking
      redirect_to bookings_path, notice: 'Booking successfully created.'
    else
      # Log the error messages for debugging purposes
      Rails.logger.error @booking.errors.full_messages.join(", ")

      # Redirect back to the workout session page with an error message
      redirect_to workout_session_path(@workout_session), alert: "Failed to create booking: #{@booking.errors.full_messages.join(", ")}"
    end
  end

  def index
    # Fetch the current user's bookings and include associated workout sessions
    @bookings = current_user.bookings.includes(:workout_session)
  end

  private

  def booking_params
    # Permit only relevant parameters (if you have additional fields to pass)
    params.require(:booking).permit(:booked_at, :status)
  end
end
