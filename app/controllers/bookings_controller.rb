class BookingsController < ApplicationController
  # ensure users are authenticated before accessing booking actions
  before_action :authenticate_user!, only: [:new, :create, :index]
  before_action :set_workout_session, only: [:new, :create]

  def new
    @booking = Booking.new
  end

  def create
    @booking = current_user.bookings.new(
      workout_session: @workout_session,
      start_time: booking_params[:start_time],
      booked_at: Time.current.in_time_zone('Tokyo')
    )

    if @booking.save
      redirect_to bookings_path, notice: 'Booking successfully created.'
    else
      Rails.logger.error @booking.errors.full_messages.join(", ")
      flash[:alert] = "Failed to create booking: #{@booking.errors.full_messages.join(", ")}"
      render :new
    end
  end

  def index
    @bookings = current_user.bookings.includes(:workout_session)
  end

  private

  def set_workout_session
    @workout_session = WorkoutSession.find(params[:workout_session_id])
  end

  def booking_params
    params.require(:booking).permit(:start_time, :booked_at, :status)
  end
end
