class ListingsController < ApplicationController
  before_action :set_listing, only: %i[ show update destroy ]

  # GET /listings
  def index
    @listings = Listing.all.map do |listing|
      {listing: listing, user_email: listing.user.email}
    end
    render json: @listings
  end

  # GET /listings/1
  def show
    # @data = @listing
    # @data.user_email: @listing.user.email
    # puts (data)
    render json: {listing: @listing, user_email: @listing.user.email}
  end

  # POST /listings
  def create
    @listing = Listing.new(listing_params)

    if @listing.save
      render json: @listing, status: :created, location: @listing
    else
      render json: @listing.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /listings/1
  def update
    if @listing.update(listing_params)
      render json: @listing
    else
      render json: @listing.errors, status: :unprocessable_entity
    end
  end

  # DELETE /listings/1
  def destroy
    if @listing.destroy!
      render json: { message: "listing deleted"}
    else
      render json: @listing.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def listing_params
      params.require(:listing).permit(:title, :address, :description, :price, :user_id, :city_id)
    end
end