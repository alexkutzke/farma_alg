class LastAnswer
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :question
  belongs_to :user
  belongs_to :answer

  index({ question_id: 1, user_id: 1 }, { unique: true })

  scope :by_user, lambda { |user|
    where(:user_id => user.id)
  }

  scope :by_user_id, lambda { |user_id|
    where(:user_id => user_id)
  }
end
