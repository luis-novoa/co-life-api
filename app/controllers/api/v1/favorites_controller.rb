class API::V1::FavoritesController < API::V1::APIController
  before_action -> { check_if_ad_exists(favorite_params[:home_id]) }, only: [:create]

  def create
    @favorite = current_user.favorites.build(favorite_params)
    @favorite.user_home = "#{@favorite.user_id}_#{@favorite.home_id}"
    if @favorite.save
      render json: @favorite, only: %i[user_id home_id], status: :created
    else
      render json: @favorite.errors, status: :unprocessable_entity
    end
  end

  def index
    current_user.admin ? @favorites = Favorite.all : @favorites ||= current_user.favorites
    render json: @favorites, only: %i[user_id home_id], status: :ok
  end

  def destroy
    if current_user.favorites.exists?(user_home: params[:user_home])
      @favorite = current_user.favorites.find_by(user_home: params[:user_home])
      @favorite.delete
      render json: 'Ad removed from your favorites list!', status: :ok
    else
      render json: "Favorite relation doesn't belong to this user.", status: :not_found
    end
  end

  private

  def favorite_params
    params.require(:favorite).permit(:home_id)
  end
end
