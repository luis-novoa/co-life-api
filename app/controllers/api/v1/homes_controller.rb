class API::V1::HomesController < API::V1::APIController
  skip_before_action :require_authentication!, only: [:show, :index]
  before_action :check_if_ad_exists, except: [:create, :index]

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
    @home = Home.find(params[:id])
    if @home.user_id == current_user.id || current_user.admin
      @home.update(home_params)
      render json: @home, status: :ok
    else
      render json: "This action isn't allowed for your account.", status: :unauthorized
    end
  end

  def destroy
    @home = Home.find(params[:id])
    if @home.user_id == current_user.id || current_user.admin
      @home.delete
      render json: 'Ad deleted!', status: :ok
    else
      render json: "This action isn't allowed for your account.", status: :unauthorized
    end
  end

  private
  def home_params
    params.require(:home).permit(:title, :address, :city, :country, :rent, :room_type, :more_info)
  end

  def check_if_ad_exists
    return render json: "This ad doesn't exist.", status: :not_found unless Home.exists?(id: params[:id])
  end
end
