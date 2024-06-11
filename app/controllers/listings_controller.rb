class ListingsController < ApplicationController
  before_action :set_listing, only: %i[ show update destroy ]
  before_action :authorize_user!, only: %i[ update destroy ]


  # GET /listings
  def index
    @listings = Listing.all.map do |listing|
      {listing: listing, user_email: listing.user.email}
    end
    render json: @listings
  end

  # GET /listings/1
  def show
    render json: {listing: @listing, user_email: @listing.user.email}
  end

  # POST /listings
  def create
    @listing = Listing.new(listing_params)
    @listing.user = get_user_from_token
    if @listing.save
      render json: @listing, status: :created
    else
      puts @listing.errors.full_messages # Ajoutez cette ligne pour afficher les erreurs de validation
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

    # Ensure the current user is the owner of the listing
    def authorize_user!
      head :forbidden unless @listing.user_id == current_user.id
    end

    # Only allow a list of trusted parameters through.
    def listing_params
      params.require(:listing).permit(:title, :address, :description, :price, :user_id, :city_id, :photo)
    end

    def get_user_from_token
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1],
                               Rails.application.credentials.devise[:jwt_secret_key]).first
      user_id = jwt_payload['sub']
      User.find(user_id.to_s)
    end
end
