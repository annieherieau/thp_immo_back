# frozen_string_literal: true

# module Users
#   class RegistrationsController < Devise::RegistrationsController # rubocop:todo Style/Documentation
#     respond_to :json

#     private

#     def respond_with(resource, _opts = {})
#       register_success && return if resource.persisted?

#       register_failed
#     end

#     def register_success
#       render json: {
#         message: 'Signed up sucessfully.',
#         user: current_user
#       }, status: :ok
#     end

#     def register_failed
#       render json: { message: 'Something went wrong.' }, status: :unprocessable_entity
#     end
#   end
# end
class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      @token = request.env['warden-jwt_auth.token']
      headers['Authorization'] = @token

      render json: {
        status: 200, 
        message: 'Signed up successfully.',
        token: @token,
        user: current_user
      }, status: :ok
    else
      render json: {
        status: 422,
        message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"
      }, status: :unprocessable_entity
    end
  end
end
