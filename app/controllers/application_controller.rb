class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :authenticate_user!

  helper_method :current_session

  protected

    def current_session
      controller_name
    end
end
