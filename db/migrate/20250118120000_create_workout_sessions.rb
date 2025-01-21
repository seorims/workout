class CreateWorkoutSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :workout_sessions do |t|
      t.string :title
      t.string :location
      t.integer :duration
      t.decimal :price, precision: 10, scale: 2
      t.text :desc
      t.references :user, null: false, foreign_key: true # Trainer

      t.timestamps
    end
  end
end
