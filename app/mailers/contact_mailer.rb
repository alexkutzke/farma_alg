class ContactMailer < ActionMailer::Base

  def send_message(contact)
    @contact = contact
    mail from: @contact.email,
         to: APP_CONFIG[:email][:account],
         reply_to: @contact.email,
         subject: "Mesagem recebida de #{@contact.name}"
  end
end
