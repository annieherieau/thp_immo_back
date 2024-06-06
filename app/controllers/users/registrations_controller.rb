# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      @token = request.env['warden-jwt_auth.token']
      headers['Authorization'] = @token

      render json: {
        status: {code: 200, 
        message: 'Signed up successfully.'},
        data: {token: @token,
        user: current_user,
        session: session}
      }, status: :ok
    else
      render json: {
        status:{ code: 422,
        message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"}
      }, status: :unprocessable_entity
    end
  end
end
