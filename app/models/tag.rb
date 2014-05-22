class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :description
  field :type, type: Integer

  belongs_to :user
  has_and_belongs_to_many :answers
end
