
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  include Pundit::Authorization

  def set_current_user
    ip = request.remote_ip
    @current_user = User.find_or_create_by_ip(ip: ip)
  end

  # Add current user to context for pundit policies
  def pundit_user
    UserContext.new(@current_user)
  end

  class UserContext
    attr_reader :current_user

    def initialize(current_user)
      @current_user = current_user
    end
  end
end