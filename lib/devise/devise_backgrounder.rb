
# Mailer proxy to send devise emails in the background
class DeviseBackgrounder

  def self.confirmation_instructions(record)
    new(:confirmation_instructions, record)
  end

  def self.reset_password_instructions(record)
    new(:reset_password_instructions, record)
  end

  def self.unlock_instructions(record)
    new(:unlock_instructions, record)
  end

  def initialize(method, record)
    @method, @record = method, record
  end

  def deliver
    # You need to hardcode the class of the Devise mailer that you
    # actually want to use. The default is Devise::Mailer.
    Devise::Mailer.delay.send(@method, @record)
  end

end
