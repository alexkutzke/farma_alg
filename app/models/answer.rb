require 'math_evaluate'

class Answer
  include Mongoid::Document
  include Mongoid::Timestamps
  include MathEvaluate

  field :response
  field :correct, type: Boolean
  field :for_test, type: Boolean
  field :tip, type: String, default: ''
  field :try_number, type: Integer
  field :lo, type: Hash
  field :exercise, type: Hash
  field :question, type: Hash

  attr_accessor :question_id

  attr_accessible :id, :response, :user_id, :question_id, :for_test

  belongs_to :user
  has_one :last_answer

  default_scope order_by([:created_at, :desc])

  scope :wrong, where(correct: false)
  scope :corrects, where(correct: true)

  before_save :store_datas, :verify_response
  after_save :register_last_answer

  def lo
    _lo = super
    Lo.new(_lo) rescue nil
  end

  def exercise
    _exercise = super
    Exercise.new(_exercise) rescue nil
  end

  def question
    _question = super
    Question.new(_question) rescue nil
  end

private
  def store_datas
    question = Question.find(self.question_id)
    self.exercise = question.exercise.as_json(include: :questions )
    self.lo = question.exercise.lo.as_json
    self.question = question.as_json
  end

  def verify_response
    question = Question.find(self.question_id)
    options = {variables: question.exp_variables}

    self.correct = MathEvaluate::Expression.eql?(question.correct_answer, self.response, options)
    if !self.correct
      set_tip
    else
      @tips_count = question.tips_counts.find_or_create_by(:user_id => self.user_id)
      self.try_number = @tips_count.tries
    end
  end

  def set_tip
    question = Question.find(self.question_id)

    @tips_count = question.tips_counts.find_or_create_by(:user_id => self.user_id)
    @tips_count.inc(:tries, 1)
    self.try_number = @tips_count.tries

    tip = self.question.tips.where(:number_of_tries.lte => @tips_count.tries).desc(:number_of_tries).first

    if tip
      self.tip = tip.content
    end
  end

  def register_last_answer
    unless self.for_test
      @last_answer = self.user.last_answers.find_or_create_by(:question_id => self.question_id)
      @last_answer.set(:answer_id, self.id)
    end
  end
end
