# frozen_string_literal: true

class UserMailer < ApplicationMailer # rubocop:todo Style/Documentation
  def reset_password_instructions(user, token)
    # je récupère l'instance user pour ensuite pouvoir la passer à la view en @user
    @user = user
    @url = "#{application_url}password/edit?reset_password_token=#{token}"

    # je permets d'envoyer l’e-mail en définissant le destinataire et le sujet.
    mail(to: @user.email, subject: 'reset_password_instructions !')
  end
end
