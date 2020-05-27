class UsersController < ApplicationController
  acts_as_token_authentication_handler_for User, fallback_to_devise: false
  before_action :require_authentication!

  def show
    return render json: "This user doesn't exist.", status: :not_found unless User.exists?(id: params[:id])

    @user = User.find(params[:id])
    if current_user.id == @user.id 
      render json: @user
    elsif current_user.admin?
      render json: @user, except: [:authentication_token]
    else
      render json: "This action isn't allowed for your account.", status: :unauthorized
    end
  end

  def index
    @users = User.all
    if current_user.admin?
      render json: @users, except: [:authentication_token]
    else
      render json: "This action isn't allowed for your account.", status: :unauthorized
    end
  end

  def destroy
    @user = User.find(params[:id])
    if current_user.id == @user.id
      @user.delete
      render json: "User deleted!", status: :ok
    elsif current_user.admin && !@user.admin
      @user.delete
      render json: "User deleted!", status: :ok
    else
      render json: "This action isn't allowed for your account.", status: :unauthorized
    end
  end
  
  def update
    @user = User.find(params[:id])
    if current_user.id == @user.id
      @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: "This action isn't allowed for your account.", status: :unauthorized
    end
  end
  
  private
  def require_authentication!
    render json: "This action requires an authentication token.", status: :unauthorized unless current_user.presence
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
