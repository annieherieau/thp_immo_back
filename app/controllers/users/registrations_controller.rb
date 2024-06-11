# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController # rubocop:todo Style/Documentation
    before_action :authenticate_user!, only: %i[update]
    before_action :set_user, only: %i[ update ]
    
    respond_to :json

    def create
      super
    end

    def update
      if @user.nil?
        render :json => { errors: "User not found" }, status: 404
      end

      if @user.valid_password?(params[:current_password])
        if params.has_key?(:password)

        end
        if @user.update(update_user_params)
          render json: {
            status: { code: 200,
             message: 'User updated successfully.' },
            data: { user: @user}
          }, status: :ok
            return
          else
            puts @listing.errors.full_messages
            render json: {
              errors: @user.errors}, status: 422
          end
      else
        render json: {errors: "wrong password"}, status: 401
      end
    end
    
    private
    def set_user
      @user = get_user_from_token
    end

    def update_user_params
      params.permit(:email, :password, :password_confirmation, :first_name, :last_name)
    end

    def get_user_from_token # rubocop:todo Naming/AccessorMethodName
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1],
                               Rails.application.credentials.devise[:jwt_secret_key]).first
      user_id = jwt_payload['sub']
      User.find(user_id.to_s)
    end
  end
end
