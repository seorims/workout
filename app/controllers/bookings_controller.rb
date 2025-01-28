class BookingsController < ApplicationController
  # ensure users are authenticated before accessing booking actions
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
    @bookings = current_user.bookings.includes(workout_session: :trainer)
  end

  def update_status
    status = params[:status]

    unless %w[accepted rejected].include?(status)
      render json: { message: 'Invalid status value' }, status: :bad_request and return
    end

    if current_user.role != 'trainer' || current_user.id != @booking.trainer_id
      render json: { message: 'Unauthorized' }, status: :forbidden and return
    end

    @booking.update(status: status)
    render json: { message: "Booking #{status}", booking: @booking }, status: :ok
  rescue StandardError => e
    render json: { message: 'Internal server error', error: e.message }, status: :internal_server_error
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
    params.require(:booking).permit(:booked_at, :status, :workout_session_id)
  end
end
