class UserMailer < ApplicationMailer
  def reset_password_instructions(user, token)
    #je récupère l'instance user pour ensuite pouvoir la passer à la view en @user
    @user = user 
    @url = application_url + 'edit?reset_password_token='+ token
    @signin_url = application_url + "users/sign_in"

    #je permets d'envoyer l’e-mail en définissant le destinataire et le sujet.
    mail(to: @user.email, subject: 'Bienvenue chez nous !') 
  end

end
