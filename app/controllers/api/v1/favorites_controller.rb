class API::V1::FavoritesController < API::V1::APIController
  before_action :check_if_ad_exists, only: [:create]

  def create
    @favorite = current_user.favorites.build(favorite_params)
    @favorite.user_home = "#{@favorite.user_id}_#{@favorite.home_id}"
    if @favorite.save
      render json: @favorite, only: [:user_id, :home_id], status: :created
    else
      render json: @favorite.errors, status: :unprocessable_entity
    end
  end

  def index
    current_user.admin ? @favorites = Favorite.all : @favorites ||= current_user.favorites
    render json: @favorites, only: [:user_id, :home_id], status: :ok
  end

  private
  def favorite_params
    params.require(:favorite).permit(:home_id)
  end

  def check_if_ad_exists
    return render json: "This ad doesn't exist.", status: :not_found unless Home.exists?(id: favorite_params[:home_id])
  end
end
