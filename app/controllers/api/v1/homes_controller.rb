class API::V1::HomesController < API::V1::APIController
  skip_before_action :require_authentication!, only: [:show, :index]

  def create
    @home = current_user.homes.build(home_params)
    if @home.save
      render json: @home, status: :created
    else
      render json: @home.errors, status: :unprocessable_entity
    end
  end

  def show
    if Home.exists?(id: params[:id])
      @home = Home.find(params[:id])
      render json: @home, status: :ok
    else
      render json: "This ad doesn't exist.", status: :not_found
    end
  end

  def index
    @homes = Home.all
    render json: @homes, status: :ok
  end

  private
  def home_params
    params.require(:home).permit(:title, :address, :city, :country, :rent, :room_type, :more_info)
  end
end
