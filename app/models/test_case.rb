# encoding: utf-8
class TestCase
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :content, type: String
  field :tip, type: String
  field :input, type: String
  field :output, type: String
  field :timeout, type: Integer, default: 1
  field :ignore_presentation, type: Boolean, default: true

  attr_accessible :id, :content, :input, :output, :timeout, :tip, :title, :ignore_presentation

  validates_presence_of :content, :timeout, :title
  validates :timeout, numericality: { only_integer: true, greater_than: 0, less_than: 100 }

  belongs_to :question
end
