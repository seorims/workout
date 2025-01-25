class ApplicationController < ActionController::Base
  # troubleshooting authenticate user via devise
  # only require authentication for controllers/actions where it's necessary
  # optionally, remove this if it's not globally required
  before_action :authenticate_user!
end
