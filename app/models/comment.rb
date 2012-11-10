class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :answer, :polymorphic => true, :inverse_of => :comments

  field :text, type: String
  field :user_id, type: Moped::BSON::ObjectId

  attr_accessible :text, :user_id
  validates_presence_of :text, :user_id

  default_scope order_by([:created_at, :asc])

  def user
    @user ||= User.find(self.user_id)
  end
end
