# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController # rubocop:todo Style/Documentation
    respond_to :json

    private

    def respond_with(_resource, _opt = {})
      @token = request.env['warden-jwt_auth.token']
      headers['Authorization'] = @token

      render json: {
        status: { code: 200,
                  message: 'Logged in successfully.' },
        data: { token: @token,
                user: current_user,
                session: }
      }, status: :ok
    end

    # rubocop:todo Metrics/MethodLength
    def respond_to_on_destroy # rubocop:todo Metrics/AbcSize, Metrics/MethodLength
      if request.headers['Authorization'].present?
        jwt_payload = JWT.decode(request.headers['Authorization'].split.last,
                                 Rails.application.credentials.devise_jwt_secret_key!).first
        current_user = User.find(jwt_payload['sub'])
      end

      if current_user
        render json: {
          status: { code: 200,
                    message: 'Logged out successfully.' }
        }, status: :ok
      else
        render json: {
          status: { code: 401,
                    message: "Couldn't find an active session." }
        }, status: :unauthorized
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
