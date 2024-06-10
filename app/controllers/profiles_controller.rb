# frozen_string_literal: true

class ProfilesController < ApplicationController # rubocop:todo Style/Documentation
  # before_action :authenticate_user!

  def show
    @user = get_user_from_token
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
  def get_user
    
  end
  def get_user_from_token # rubocop:todo Naming/AccessorMethodName
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1],
                             Rails.application.credentials.devise[:jwt_secret_key]).first
    user_id = jwt_payload['sub']
    User.find(user_id.to_s)
  end
end
