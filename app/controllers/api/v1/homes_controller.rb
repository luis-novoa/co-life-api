class API::V1::HomesController < API::V1::APIController
  skip_before_action :require_authentication!, only: %i[show index]
  before_action -> { check_if_ad_exists(params[:id]) },  except: %i[create index] 
  before_action :check_privilege, only: %i[destroy update]

  def create
    @home = current_user.homes.build(home_params)
    if @home.save
      render json: @home, status: :created
    else
      render json: @home.errors, status: :unprocessable_entity
    end
  end

  def show
    @home = Home.find(params[:id])
    render json: @home, status: :ok
  end

  def index
    @homes = Home.all
    render json: @homes, status: :ok
  end

  def update
    @home.update(home_params)
    render json: @home, status: :ok
  end

  def destroy
    @home.delete
    render json: 'Ad deleted!', status: :ok
  end

  private

  def home_params
    params.require(:home).permit(:title, :address, :city, :country, :rent, :room_type, :more_info)
  end

  def check_privilege
    @home = Home.find(params[:id])
    render json: "This action can only be performed on your own ID. Log in as an administrator to perform this action another user's ID.", status: :unauthorized unless (@home.user_id == current_user.id || current_user.admin)
  end
end
