class UserMailer < ActionMailer::Base
  default :from => "nao-responda-farma-alg@c3sl.ufpr.br"
  def registration_confirmation(user)
    @user = user
    #mail(:to => user.email, :subject => "Registered")
    mail(:to => "alexkutzke@gmail.com", :subject => "Registered")

  end
end
