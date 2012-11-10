class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :content, type: String
  field :correct_answer, type: String
  field :available, type: Boolean, default: false
  field :position, type: Integer
  #field :compartion_type, type: String, default: 'expression'
  field :exp_variables, type: Array, default: []
  field :many_answers, type: Boolean, default: false

  has_many :tips_counts

  default_scope desc(:position)

  before_create :set_position
  before_save :set_exp_variables

  attr_accessible :id, :title, :content, :correct_answer, :available, :comparation_type

  validates_presence_of :title, :content, :correct_answer
  validates :available, :inclusion => {:in => [true, false]}
  #validates :compartion_type, :inclusion => {:in => ['result', 'expression']}

  belongs_to :exercise
  has_many :tips, dependent: :delete
  has_many :tips_counts, dependent: :delete
  has_many :last_answers, dependent: :delete #one last answer for each user

private
  def set_position
    self.position = Time.now.to_i
  end

  def set_exp_variables
    self.many_answers = self.correct_answer.to_s.include?(';')
    self.exp_variables = self.correct_answer.scan(/[a-z][a-z0-9_]*/)
  end
end
