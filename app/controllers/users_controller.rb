class UsersController < ApplicationController
  acts_as_token_authentication_handler_for User, fallback_to_devise: false
  before_action :require_authentication!
  before_action :check_if_user_exists, except: %i[index]
  before_action :set_user, except: %i[index]
  before_action :check_profile_ownership, except: %i[index update]

  def show
    return render json: @user, except: %i[authentication_token], status: :ok if current_user.admin? && current_user.id != @user.id
    render json: @user, status: :ok
  end

  def index
    @users = User.all
    if current_user.admin?
      render json: @users, except: %i[authentication_token]
    else
      render json: "Log in as an administrator to perform this action.", status: :unauthorized
    end
  end

  def destroy
    unless @user.admin
      @user.delete
      render json: 'User deleted!', status: :ok
    end

  end

  def update
    if current_user.id == @user.id
      @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: "This action can only be performed on your own ID.", status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def check_if_user_exists
    return render json: "This user doesn't exist.", status: :not_found unless User.exists?(id: params[:id])
  end

  def check_profile_ownership
    render json: "This action can only be performed on your own ID. Log in as an administrator to perform this action another user's ID.", status: :unauthorized unless current_user.id == @user.id || current_user.admin
  end
end
