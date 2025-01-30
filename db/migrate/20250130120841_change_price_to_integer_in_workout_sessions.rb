class ChangePriceToIntegerInWorkoutSessions < ActiveRecord::Migration[7.1]
  def change
    change_column :workout_sessions, :price, :integer
  end
end
