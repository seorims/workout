class BookingsController < ApplicationController
  # Ensure users are authenticated before creating a booking
  before_action :authenticate_user!, only: [:create]

  def create
    @workout_session = WorkoutSession.find(params[:workout_session_id])
    @booking = current_user.bookings.new(
      workout_session: @workout_session,
      booked_at: Time.now.in_time_zone('Tokyo')
    )

    if @booking.save
      redirect_to bookings_path, notice: 'Booking successfully created.'
    else
      Rails.logger.error @booking.errors.full_messages.join(", ")
      redirect_to workout_session_path(@workout_session), alert: "Failed to create booking: #{@booking.errors.full_messages.join(", ")}"
    end
  end

  def index
    @bookings = current_user.bookings.includes(:workout_session)
  end

  private

  def booking_params
    params.require(:booking).permit(:booked_at, :status)
  end
end
