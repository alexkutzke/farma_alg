class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :content, type: String
  field :input, type: String
  field :output, type: String   
#  field :correct_answer, type: String
  field :available, type: Boolean, default: false
  field :position, type: Integer
  #field :compartion_type, type: String, default: 'expression'
#  field :exp_variables, type: Array, default: []
#  field :many_answers, type: Boolean, default: false
#  field :eql_sinal, type: Boolean, default: false

  default_scope desc(:position)

  before_create :set_position
#  before_save :set_exp_variables

  attr_accessible :id, :title, :content, :available, :input, :output 

  validates_presence_of :title, :content 
  validates :available, :inclusion => {:in => [true, false]}
  #validates :compartion_type, :inclusion => {:in => ['result', 'expression']}

  belongs_to :exercise
  has_many :tips, dependent: :delete
  has_many :test_cases, dependent: :delete
  has_many :tips_counts, dependent: :delete
  has_many :last_answers, dependent: :delete #one last answer for each user

#  def correct_answer=(correct_answer)
#    super(correct_answer.downcase)
#  end

private
  def set_position
    self.position = Time.now.to_i
  end

#  def set_exp_variables
#    self.eql_sinal = self.correct_answer.to_s.include?('=')
#    self.many_answers = self.correct_answer.to_s.include?(';')
#    self.exp_variables = self.correct_answer.scan(/[a-z][a-z0-9_]*/).uniq
#  end
end
