class WorkoutSessionsController < ApplicationController
  def index
    @workout_sessions = WorkoutSession.all

    # add dummy placeholder sessions if none exist
    if @workout_sessions.empty?
      @workout_sessions = Array.new(3) do |i|
        WorkoutSession.new(
          title: "Session #{i + 1}",
          location: "Placeholder Location",
          duration: 60,
          price: 20.0,
          desc: "This is a placeholder description for styling purposes.",
          user_id: nil # No associated trainer
        )
      end
    end
  end
end
