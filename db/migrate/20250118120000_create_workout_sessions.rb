class CreateWorkoutSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :workout_sessions do |t|
      t.string :location
      t.integer :duration
      t.decimal :price
      t.text :desc
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

# to simulate pull request
