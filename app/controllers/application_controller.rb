class ApplicationController < ActionController::Base
  # troubleshooting authenticate user via devise
  # only require authentication for controllers/actions where it's necessary
  # optionally, remove this if it's not globally required
  include Devise::Controllers::Helpers

  before_action :authenticate_user!
  before_action :store_user_location!, if: :storable_location?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role])
  end

  private

  # Store the location only if it's storable
  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  # Determine if the location should be stored
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  # Redirect the user after signing in
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  # Redirect the user after signing out (optional)
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
