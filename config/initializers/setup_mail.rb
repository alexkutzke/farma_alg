ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "educacional.c3sl.ufpr.br",
  :user_name            => "carrie.ufpr",
  :password             => "carrie123",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
