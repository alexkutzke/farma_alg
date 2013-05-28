require 'math_evaluate'

include ActionView::Helpers::TextHelper

class Answer

  include Mongoid::Document
  include Mongoid::Timestamps
  include MathEvaluate

  field :response
  field :correct, type: Boolean
  field :for_test, type: Boolean
  field :compile_errors
#  field :tip, type: String, default: ''
#  field :try_number, type: Integer

  field :lo, type: Hash
  field :exercise, type: Hash
  field :question, type: Hash
  field :team, type: Hash

  field :team_id, type: Moped::BSON::ObjectId
  field :lo_id, type: Moped::BSON::ObjectId
  field :exercise_id, type: Moped::BSON::ObjectId
  field :question_id, type: Moped::BSON::ObjectId

  alias :super_exercise :exercise
  alias :super_question :question

  attr_accessible :id, :response, :user_id, :team_id, :lo_id, :exercise_id, :question_id, :for_test

  belongs_to :user
  has_one :last_answer
  embeds_many :comments, :as => :commentable

  #default_scope desc(:created_at)

  scope :wrong, where(correct: false, :team_id.ne => nil, :for_test.ne => true)
  scope :corrects, where(correct: true, :team_id.ne => nil, :for_test.ne => true)
  scope :every, excludes(team_id: nil, for_test: true)

  before_create :verify_response, :store_datas
  after_create :register_last_answer, :update_questions_with_last_answer

  def self.search(page, params = nil, team_ids = nil)
    if team_ids
      if params
        Answer.excludes(team_id: nil, for_test: true).where(params).in(team_id: team_ids).page(page).per(20)
      else
        Answer.excludes(team_id: nil, for_test: true).in(team_id: team_ids).page(page).per(20)
      end
    else
      if params
        Answer.excludes(team_id: nil, for_test: true).where(params).page(page).per(20)
      else
        Answer.excludes(team_id: nil, for_test: true).page(page).per(20)
      end
    end
  end

  def lo
    @_lo ||= Lo.new(super) rescue nil
  end

  def exercise
    @_exercise ||= Exercise.new(super) rescue nil
  end

  def exercise_as_json
    exercises = super_exercise
    %w(position available lo_id updated_at created_at).each {|e| exercises.delete(e)}
    exercises['questions'].each do |question|
      question['answered'] = question['id'] == self.question_id
      %w(position available lo_id updated_at tips correct_answer created_at).each {|e| question.delete(e)}
    end
    exercises
  end

  def question
    @_question ||= Question.new(super) rescue nil
  end

  def question_as_json
    question = super_question
    %w(position available lo_id updated_at tips exercise_id correct_answer).each {|e| question.delete(e)}
    question
  end

  def team
    @_team ||= Team.new(super) rescue nil
  end

# Need store all information for retroaction
private
  def update_questions_with_last_answer
   _exercise = super_exercise
   _exercise['questions'].each do |question|
      question['id'] = question['_id']
      question.delete('_id')

      question_obj = Question.find(question['id'])

      la = question_obj.last_answers.by_user_id(self.user_id)
      if la && la.first
        question['last_answer'] = la.first.as_json
        question['last_answer']['id'] = la.first.id
        question['last_answer'].delete('_id')
        question['last_answer']['response'] = la.first.answer.response
        question['last_answer']['correct'] = la.first.answer.correct
#        question['last_answer']['tip'] = la.first.answer.tip
#        question['last_answer']['try_number'] = la.first.answer.try_number
      end

#      tries = question_obj.tips_counts.where(user_id: self.user_id).first.try(:tries) || 0
#      question['tries'] = tries
      end
    self.update_attribute('exercise', _exercise)
  end

  def store_datas
    question = Question.find(self.question_id)
    self.exercise = question.exercise.as_json(include: {questions: {include: :tips }})
    self.lo = question.exercise.lo.as_json
    self.question = question.as_json(include: :tips)
    self.team = Team.find(self.team_id).as_json if self.team_id
  end

  def verify_response
    question = Question.find(self.question_id)
    #options = {variables: question.exp_variables}

    #if question.many_answers?
    #  self.correct= MathEvaluate::Expression.eql_with_many_answers?(question.correct_answer, self.response, options)
    #elsif question.eql_sinal?
    #  self.correct= MathEvaluate::Expression.eql_with_eql_sinal?(question.correct_answer, self.response, options)
    #else
    #  self.correct= MathEvaluate::Expression.eql?(question.correct_answer, self.response, options)
    #end

    compile_errors = ""
    correct = Hash.new
    tmp = Time.now.to_i

    File.open("/tmp/#{tmp}-response.pas", 'w') {|f| f.write(self.response) }
      
    result = `fpc /tmp/#{tmp}-response.pas -Fe/tmp/#{tmp}-compile_errors`
    if $?.exitstatus == 1
      self.compile_errors = simple_format `cat /tmp/#{tmp}-compile_errors`
      self.correct = false
    else
      question.test_cases.each do |t|
        File.open("/tmp/#{tmp}-input-#{t.id}.dat", 'w') {|f| f.write(t.input) }
        File.open("/tmp/#{tmp}-output-#{t.id}.dat", 'w') {|f| f.write(t.output) }
      
        `/Users/alexkutzke/Downloads/timeout3 -t #{t.timeout} /tmp/#{tmp}-response < /tmp/#{tmp}-input-#{t.id}.dat > /tmp/#{tmp}-output_response-#{t.id}.dat`
        `diff /tmp/#{tmp}-output_response-#{t.id}.dat /tmp/#{tmp}-output-#{t.id}.dat`

        if $?.exitstatus == 0
          correct[t.id] = 1
        elsif $?.exitstatus == 143
          correct[t.id] = 2
        else
          correct[t.id] = 3
        end
      end

      self.correct = true
      correct.each do |id,r|
        if not r == 1 
          self.correct = false
        end
      end
    end

#    if !self.correct
#      set_tip
#    else
#      @tips_count = question.tips_counts.find_or_create_by(:user_id => self.user_id)
#      self.try_number= @tips_count.tries
#    end
  end

  def set_tip
    question = Question.find(self.question_id)

    @tips_count = question.tips_counts.find_or_create_by(:user_id => self.user_id)
    @tips_count.inc(:tries, 1)
    self.try_number = @tips_count.tries

    tip = question.tips.where(:number_of_tries.lte => @tips_count.tries).desc(:number_of_tries).first
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
