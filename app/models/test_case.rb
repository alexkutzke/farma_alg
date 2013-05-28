# encoding: utf-8
class TestCase
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String
  field :input, type: String
  field :output, type: String
  field :timeout, type: Integer, default: 1

  attr_accessible :id, :content, :input, :output, :timeout

  validates_presence_of :content, :timeout
  validates :timeout, numericality: { only_integer: true, greater_than: 0, less_than: 100 }

  belongs_to :question
end
