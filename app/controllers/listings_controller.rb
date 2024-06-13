class ListingsController < ApplicationController
  before_action :set_listing, only: %i[ show update destroy ]
  before_action :set_city, only: %i[index_per_city]
  before_action :set_city, only: %i[index_per_city]
  before_action :authorize_user!, only: %i[ update destroy ]

  # GET /listings
  def index
    @listings = Listing.all.sort().reverse().map { |listing| listing_with_photo_url(listing).as_json.merge(user_email: listing.user.email, city_name: listing.city.name) }
    render json: @listings
  end
  #GET /listings/search
  def search
    @listings = Listing.where("title LIKE ? OR description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%").map { |listing| listing_with_photo_url(listing).as_json.merge(user_email: listing.user.email, city_name: listing.city.name) }
  end

  # GET /cities/:city_id/listings
  def index_per_city
    @filtered_listings = Listing.where(city_id: @city_id).map { |listing| listing_with_photo_url(listing).as_json.merge(user_email: listing.user.email, city_name: listing.city.name) }
    render json: @filtered_listings
  end

  # get /my_listings
  def my_listings
    @listings = current_user.listings.sort().reverse()
    @listings_with_photos = @listings.map do |listing|
      listing_with_photo_url(listing).as_json.merge(user_email: listing.user.email, city_name: listing.city.name)
    end
    render json: @listings_with_photos
  end

  # GET /listings/1
  def show
    render json: listing_with_photo_url(@listing).as_json.merge(user_email: @listing.user.email, city_name: @listing.city.name)
  end

  # POST /listings
  def create
    @listing = Listing.new(listing_params)
    @listing.user = get_user_from_token
    if @listing.save
      render json: listing_with_photo_url(@listing).as_json.merge(user_email: @listing.user.email, city_name: @listing.city.name), status: :created
    else
      puts @listing.errors.full_messages # Display validation errors
      render json: @listing.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /listings/1
  def update
    if @listing.update(listing_params)
      render json: listing_with_photo_url(@listing).as_json.merge(user_email: @listing.user.email, city_name: @listing.city.name)
    else
      render json: @listing.errors, status: :unprocessable_entity
    end
  end

  # DELETE /listings/1
  def destroy
    if @listing.destroy!
      render json: { message: "listing deleted" }
    else
      render json: @listing.errors, status: :unprocessable_entity
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end

    def set_city
      @city_id = params[:city_id].to_i
    end

    def set_user
      @user = User.find(params[:user_id].to_i)
    end

    # Ensure the current user is the owner of the listing
    def authorize_user!
      head :forbidden unless @listing.user_id == current_user.id
    end

    # Only allow a list of trusted parameters through.
    def listing_params
      params.require(:listing).permit(:title, :address, :description, :price, :city_id, :photo, :user_id, :surface_area, :number_of_rooms, :furnished, :bonus)
    end

    def get_user_from_token
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], Rails.application.credentials.devise[:jwt_secret_key]).first
      user_id = jwt_payload['sub']
      User.find(user_id.to_s)
    end

    # Helper method to include the photo URL in the listing JSON
    def listing_with_photo_url(listing)
      listing.as_json.merge(photo_url: listing.photo.attached? ? url_for(listing.photo) : nil)
    end
end
