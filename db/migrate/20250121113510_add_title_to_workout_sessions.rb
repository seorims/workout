class AddTitleToWorkoutSessions < ActiveRecord::Migration[7.1]
  def change
    add_column :workout_sessions, :title, :string
  end
end
