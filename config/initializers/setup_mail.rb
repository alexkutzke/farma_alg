ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "educacional.c3sl.ufpr.br",
  :user_name            => APP_CONFIG[:email][:account],
  #:user_name            => "carrie.ufpr",
  #:password             => "carrie123",
  :password             => APP_CONFIG[:email][:passwd],
  :authentication       => "plain",
  :enable_starttls_auto => true
}
