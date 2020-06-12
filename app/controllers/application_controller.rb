class ApplicationController < ActionController::API
  private

  def require_authentication!
    render json: 'This action requires an authentication token.', status: :unauthorized unless current_user.presence
  end
end
