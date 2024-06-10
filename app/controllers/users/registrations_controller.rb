# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController # rubocop:todo Style/Documentation
    respond_to :json

    def create
      super
    end

    def update
      super
    end
    
    private

    # def respond_with(resource, _opts = {}) # rubocop:todo Metrics/MethodLength
    #   if resource.persisted?
    #     @token = request.env['warden-jwt_auth.token']
    #     headers['Authorization'] = @token

    #     render json: {
    #       status: { code: 200,
    #                 message: 'Signed up successfully.' },
    #       data: { token: @token,
    #               user: current_user,
    #               session: }
    #     }, status: :ok
    #   else
    #     render json: {
    #       status: { code: 422,
    #                 message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" }
    #     }, status: :unprocessable_entity
    #   end
    # end
  end
end
