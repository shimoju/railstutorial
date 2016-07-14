class Api::ApplicationController < ActionController::Base

  private
    def check_auth_token
      render nothing: true, status: :unauthorized and return if decode_auth_token.nil?
    end

    def current_user
      return @current_user unless @current_user.nil?
      user_id = decode_auth_token.first["user_id"]
      @current_user = User.find(user_id)
    end

    def admin_user
      render nothing: true, status: :forbidden and return unless current_user.admin?
    end

    def decode_auth_token
      auth_header = request.authorization
      return nil if auth_header.nil?
      token = auth_header.split(" ").last
      User.decode_jwt(token)
    end
end
