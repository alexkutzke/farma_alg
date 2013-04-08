class ContactsController < ApplicationController
  respond_to :json

  def create
    @contact = Contact.new(params['contact'])

    if @contact.valid?
      ContactMailer.send_message(@contact).deliver
      respond_with(@contact)
    else
      respond_with(@contact, status: 422)
    end
  end
end
