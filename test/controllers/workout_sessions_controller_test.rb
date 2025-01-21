require "test_helper"

class WorkoutSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get workout_sessions_index_url
    assert_response :success
  end
end
