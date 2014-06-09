# encoding: utf-8
class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :description
  field :type, type: Integer
  field :primary, type: Boolean, default: false

  belongs_to :user
  has_and_belongs_to_many :answers
end
