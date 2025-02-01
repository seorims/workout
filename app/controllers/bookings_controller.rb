class BookingsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :index, :cancel] # Ensure create is listed
  before_action :authenticate_trainer!, only: [:update_status, :destroy]
  before_action :set_booking, only: [:update_status, :cancel, :destroy]
  before_action :set_workout_session, only: [:new, :create]

  def new
    @booking = Booking.new
  end

  def create
    @booking = current_user.bookings.new(
      workout_session: @workout_session,
      start_time: booking_params[:start_time],
      booked_at: Time.current.in_time_zone('Tokyo'),
      status: 'pending'
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
      @sessions = WorkoutSession.where(user_id: current_user.id).includes(:bookings)
      @bookings = Booking.where(workout_session_id: @sessions.pluck(:id)).includes(:user)
    else
      @bookings = current_user.bookings.includes(workout_session: :trainer)
    end
  end



  def update_status
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

  def cancel

    # cancel only if it's pending (already confirmed bookings cannot be cancelled)
    if @booking.status == 'pending'
      @booking.update(status: 'cancelled')
      redirect_to bookings_path, notice: "Booking has been cancelled."
    else
      redirect_to bookings_path, alert: "You can only cancel pending bookings."
    end
  end

  def destroy
    Rails.logger.info "Current User ID: #{current_user.id}, Booking Owner ID: #{@booking.user_id}, Current User Role: #{current_user.role}"

    if current_user.role == 'trainer' || current_user == @booking.user
      Rails.logger.info "Deleting Booking ID: #{@booking.id}"
      @booking.destroy
      redirect_to bookings_path, notice: "Booking successfully deleted."
    else
      Rails.logger.warn "Unauthorized delete attempt by User ID: #{current_user.id}"
      redirect_to bookings_path, alert: "You are not authorized to delete this booking."
    end
  end




  private

  def set_workout_session
    @workout_session = WorkoutSession.find_by(id: params[:workout_session_id])
    unless @workout_session
      redirect_to workout_sessions_path, alert: "Session not found."
    end
  end

  def set_booking
    @booking = Booking.find_by(id: params[:id])
    redirect_to bookings_path, alert: "Booking not found." unless @booking
  end

  def booking_params
    params.require(:booking).permit(:booked_at, :status, :start_time)
  end
end
