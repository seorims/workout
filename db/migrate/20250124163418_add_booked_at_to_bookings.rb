class AddBookedAtToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :booked_at, :datetime
  end
end
