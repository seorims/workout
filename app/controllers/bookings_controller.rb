class BookingsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :index]
  before_action :authenticate_trainer!, only: [:update_status]
  before_action :set_workout_session, only: [:new, :create]
  before_action :set_booking, only: [:update_status]

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
      flash[:alert] = "Failed to create booking: #{@booking.errors.full_messages.join(", " )}"
      render :new
    end
  end

  def index
    if current_user.role == 'trainer'
      @sessions = current_user.workout_sessions.includes(bookings: :user)
      @bookings = current_user.workout_sessions.flat_map(&:bookings)
    else
      @bookings = current_user.bookings.includes(workout_session: :trainer)
    end
  end

  def update_status
    @booking = Booking.find(params[:id])

    if current_user.role != 'trainer'
      redirect_to bookings_path, alert: "You are not authorized to update bookings."
      return
    end

    new_status = params[:status]

    unless %w[confirmed cancelled].include?(new_status)
      redirect_to bookings_path, alert: "Invalid status update."
      return
    end

    if @booking.update(status: new_status)
      redirect_to bookings_path, notice: "Booking has been #{new_status}."
    else
      redirect_to bookings_path, alert: "Failed to update booking."
    end
  end

  private

  def set_workout_session
    @workout_session = WorkoutSession.find(params[:workout_session_id])
  end

  def set_booking
    @booking = Booking.find_by(id: params[:id])
    render json: { message: 'Booking not found' }, status: :not_found unless @booking
  end

  def booking_params
    params.require(:booking).permit(:booked_at, :status, :start_time)
  end
end
