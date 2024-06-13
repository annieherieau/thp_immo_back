class ListingsController < ApplicationController
  before_action :set_listing, only: %i[show update destroy]
  before_action :set_city, only: %i[index_per_city]
  before_action :authorize_user!, only: %i[update destroy]

  # GET /listings
  def index
    @listings = Listing.all.order(created_at: :desc).map do |listing|
      listing_with_details(listing)
    end
    render json: @listings
  end

  # GET /listings/search
  def search
    @listings = Listing.where("title LIKE ? OR description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%").map do |listing|
      listing_with_details(listing)
    end
    render json: @listings
  end

  # GET /cities/:city_id/listings
  def index_per_city
    @filtered_listings = Listing.where(city_id: @city_id).map do |listing|
      listing_with_details(listing)
    end
    render json: @filtered_listings
  end

  # GET /listings/filtered
  def filtered
    @listings = Listing.all
    @listings = @listings.where(city_id: params[:city_id]) if params[:city_id].present?
    @listings = @listings.where(furnished: ActiveModel::Type::Boolean.new.cast(params[:furnished])) if params[:furnished].present?
    @listings = @listings.where("price >= ?", params[:price_min]) if params[:price_min].present?
    @listings = @listings.where("price <= ?", params[:price_max]) if params[:price_max].present?
    @listings = @listings.where("surface_area >= ?", params[:surface_min]) if params[:surface_min].present?
    @listings = @listings.where("surface_area <= ?", params[:surface_max]) if params[:surface_max].present?
    @listings = @listings.where("number_of_rooms >= ?", params[:rooms_min]) if params[:rooms_min].present?
    @listings = @listings.where("number_of_rooms <= ?", params[:rooms_max]) if params[:rooms_max].present?

    case params[:sort]
    when "price_asc"
      @listings = @listings.order(price: :asc)
    when "price_desc"
      @listings = @listings.order(price: :desc)
    when "surface_area_asc"
      @listings = @listings.order(surface_area: :asc)
    when "surface_area_desc"
      @listings = @listings.order(surface_area: :desc)
    when "number_of_rooms_asc"
      @listings = @listings.order(number_of_rooms: :asc)
    when "number_of_rooms_desc"
      @listings = @listings.order(number_of_rooms: :desc)
    end

    @filtered_listings = @listings.map do |listing|
      listing_with_details(listing)
    end
    render json: @filtered_listings
  end

  # GET /my_listings
  def my_listings
    @listings = current_user.listings.order(created_at: :desc).map do |listing|
      listing_with_details(listing)
    end
    render json: @listings
  end

  # GET /listings/1
  def show
    render json: listing_with_details(@listing)
  end

  # POST /listings
  def create
    @listing = Listing.new(listing_params)
    @listing.user = get_user_from_token

    if @listing.save
      render json: listing_with_details(@listing), status: :created
    else
      render json: @listing.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /listings/1
  def update
    if @listing.update(listing_params)
      render json: listing_with_details(@listing)
    else
      render json: @listing.errors, status: :unprocessable_entity
    end
  end

  # DELETE /listings/1
  def destroy
    if @listing.destroy
      render json: { message: "Listing deleted" }
    else
      render json: @listing.errors, status: :unprocessable_entity
    end
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def set_city
    @city_id = params[:city_id].to_i
  end

  def authorize_user!
    head :forbidden unless @listing.user_id == current_user.id
  end

  def listing_params
    params.require(:listing).permit(:title, :address, :description, :price, :city_id, :photo, :surface_area, :number_of_rooms, :furnished, :bonus)
  end

  def get_user_from_token
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], Rails.application.credentials.devise[:jwt_secret_key]).first
    user_id = jwt_payload['sub']
    User.find(user_id.to_s)
  end

  def listing_with_details(listing)
    listing.as_json.merge(
      user_email: listing.user.email,
      city_name: listing.city.name,
      photo_url: listing.photo.attached? ? url_for(listing.photo) : nil
    )
  end
end
