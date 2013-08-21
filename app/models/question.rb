class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :content, type: String
  field :available, type: Boolean, default: false
  field :position, type: Integer
  field :languages

  default_scope desc(:position)

  before_create :set_position

  attr_accessible :id, :title, :content, :available, :languages

  validates_presence_of :title, :content 
  validates :available, :inclusion => {:in => [true, false]}

  belongs_to :exercise
  has_many :test_cases, dependent: :delete
  has_many :last_answers, dependent: :delete #one last answer for each user

private
  def set_position
    self.position = Time.now.to_i
  end

end
