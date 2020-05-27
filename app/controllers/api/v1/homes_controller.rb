class API::V1::HomesController < API::V1::APIController
  def create
    @home = current_user.homes.build(home_params)
    if @home.save
      render json: @home, status: :created
    else
      render json: @home.errors, status: :unprocessable_entity
    end
  end

  private
  def home_params
    params.require(:home).permit(:title, :address, :city, :country, :rent, :room_type, :more_info)
  end
end
