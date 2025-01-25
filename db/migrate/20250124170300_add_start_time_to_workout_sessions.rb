class AddStartTimeToWorkoutSessions < ActiveRecord::Migration[7.1]
  def change
    add_column :workout_sessions, :start_time, :datetime
  end
end
