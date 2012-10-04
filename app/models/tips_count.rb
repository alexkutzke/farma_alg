class TipsCount
  include Mongoid::Document
  include Mongoid::Timestamps

  field :tries, type: Integer, default: 0

  belongs_to :question
  belongs_to :user
end
