class Progress
  include Mongoid::Document
  include Mongoid::Timestamps

  field :team_id, type: Moped::BSON::ObjectId
  field :question_id, type: Moped::BSON::ObjectId
  field :user_id, type: Moped::BSON::ObjectId
  field :value, type: Float, default: 0.0
end