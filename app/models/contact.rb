class Contact
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :email, type: String
  field :message, type: String

  validates_presence_of :name, :message
  validates_format_of :email, with: Devise::email_regexp
end
