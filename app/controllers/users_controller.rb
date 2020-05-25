class UsersController < ApplicationController
  acts_as_token_authentication_handler_for User, fallback_to_devise: false
  before_action :require_authentication!

  def show
    @user = User.find(params[:id])
    if current_user.id == @user.id
      render json: @user
    else
      render json: "This action isn't allowed for your account.", status: :unauthorized
    end
  end
  
  private
  def require_authentication!
    render json: "This action requires an authentication token.", status: :unauthorized unless current_user.presence
  end 
end
