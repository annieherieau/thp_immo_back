# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # POST /resource/password
  # envoi du mail reset_password_instructions
  # adresse dans le mail : /password/edit?reset_password_token=abcdef
  def create
    if params[:email].blank?
      render json: {
        status:{ code: 422,
        message: "Email not present."}
      }, status: :unprocessable_entity
    end
    @user = User.find_by(email: params[:email].downcase)
   
    # if user.present? && user.confirmed_at?
    if @user.present?
      #  générer le reset_password_token
      @token = @user.generate_password_token!
      headers['Authorization'] = "Bearer #{@token}"

      # envoyer l'email
      if @user.send_reset_password_instructions(@token)
        render json: {
          status: {code: 200,
            message: 'Instruction email successfully sent. Please check your spam.'}
        }, status: :ok
      else
        render json: {
          status: {code: 418,
            message: 'Something gets wrong. Please try later.'}
        }, status: :ok
      end
    else
      render json: {
        status: {code: 404,
          message: 'Email address not found. Please check and try again.'},
      }, status: :not_found
     
    end
  end

  # PUT /resource/password
  def update
    # reset_password_token
    @reset_password_token = request.headers['Authorization'].sub("Bearer ", "")
    if @reset_password_token.blank?
      render json: {
        status: {code: 422,
        message: "Reset_password_token missing in headers."}
      }, status: :unprocessable_entity
    end

    # trouver user
    @user = find_user_by_reset_password_token(@reset_password_token)
    if @user.present? && @user.password_token_valid?
      if @user.reset_password!(params[:password])
        render json: {
          status: {code: 200,
          message: "Password successfully updated"}
        }, status: :ok
      else
        render json: {
        status: {code: 422,
        message: "Password couldn't be updated successfully. #{@user.errors.full_messages}"}
        }, status: :unprocessable_entity
      end
    else
      render json: {
        status: {code: 404,
        message: 'Link not valid or expired. Try generating a new link.'}
      }, status: :not_found
    end
  end

  private
  protected
  def find_user_by_reset_password_token(token)
    hashed = Devise.token_generator.digest(User, :reset_password_token, token)
    User.find_by(reset_password_token: hashed)
  end
  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
