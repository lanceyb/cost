class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: "403: 很抱歉，您没有权限去操作该页面！"
  end

  attr_accessor :show_flash

  helper_method :current_session

  protected

    def current_session
      controller_name
    end

    def after_sign_out_path_for scope
      new_user_session_path
    end
end
