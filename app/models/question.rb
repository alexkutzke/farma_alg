class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :content, type: String
  field :correct_answer, type: String
  field :available, type: Boolean, default: false
  field :position, type: Integer

  before_create :set_position

  attr_accessible :id, :title, :content, :correct_answer, :available

  validates_presence_of :title, :content, :correct_answer
  validates :available, :inclusion => {:in => [true, false]}

  belongs_to :exercise

private
  def set_position
    self.position = Time.now.to_i
  end
end
