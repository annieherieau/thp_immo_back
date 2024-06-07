# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # envoi du mail reset_password_instructions
  # adresse dans le mail : /resource/password/edit?reset_password_token=abcdef
  def create
    puts('*'*30)
    puts(request.body)
    puts('*'*30)
    if params[:email].blank?
      render json: {error: 'Email not present'}
    end

    @user = User.find_by(email: params[:email].downcase)
    @url = params[:url]
    puts(@url)
    # if user.present? && user.confirmed_at?
    if @user.present?
      # user.generate_password_token!
      # SEND EMAIL HERE
      puts('!'*30)
      @reset_password_token = @user.send_reset_password_instructions
      @user.send_test_email
      if @reset_password_token 
        render json: {
          status: {code: 200,
            message: 'Instruction email successfully sent. Please check your spam.'},
          data: {reset_password_token: @reset_password_token,
            user: @user}
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

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
