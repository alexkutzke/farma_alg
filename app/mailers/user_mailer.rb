class UserMailer < ActionMailer::Base
  #default :from => "farma.alg@gmail.com"
  def registration_confirmation(user)
    @user = user
    #mail(:to => user.email, :subject => "Registered")
    mail(:to => "alexkutzke@gmail.com", :subject => "Registered")

  end
end
