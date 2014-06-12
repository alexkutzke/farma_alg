# encoding: utf-8
class Recommendation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :type
  field :item, type: Hash

  belongs_to :user
end
