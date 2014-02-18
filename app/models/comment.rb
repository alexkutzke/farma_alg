class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  #embedded_in :answer, :polymorphic => true, :inverse_of => :comments
  belongs_to :answer

  field :text, type: String
  field :user_id, type: Moped::BSON::ObjectId
  field :team_id, type: Moped::BSON::ObjectId
  field :question_id, type: Moped::BSON::ObjectId
  field :target_user_id, type: Moped::BSON::ObjectId  

  attr_accessible :text, :user_id, :created_at, :team_id, :question_id, :target_user_id
  validates_presence_of :text, :user_id

  default_scope order_by([:created_at, :asc])

  def user
    @user ||= User.find(self.user_id)
  end

  def can_destroy?(user)
    self.created_at >= 15.minutes.ago && self.user_id == user.id
  end
end
