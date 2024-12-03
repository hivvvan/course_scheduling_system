class ApplicationController < ActionController::Base
  unless Rails.env.production?
    around_action :n_plus_one_detection
  end
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_student!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :student_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  private

  def n_plus_one_detection
    Prosopite.scan
    yield
  ensure
    Prosopite.finish
  end
end
