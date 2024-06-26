# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  # GET /my_profile
  def show
    if @user
      render json: {
        status: {code: 200,
        message: "If you see this, you're in!"},
        user: @user
      }
    else
      render json: {
        status: {code: 404,
        message: "User Not Found"}
      }
    end
  end

  private
  def set_user
    @user = get_user_from_token
  end
  def get_user_from_token # rubocop:todo Naming/AccessorMethodName
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1],
                             Rails.application.credentials.devise[:jwt_secret_key]).first
    user_id = jwt_payload['sub']
    User.find(user_id.to_s)
  end

    # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, :first_name, :first_name, :password, :password_confirmation)
  end

end
