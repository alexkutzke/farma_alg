require 'math_evaluate'

class RetroactionAnswer
  include Mongoid::Document
  include Mongoid::Timestamps
  include MathEvaluate

  field :response
  field :correct, type: Boolean
  field :compile_errors
  field :results, type: Hash
  field :try_number, type: Integer, default: 0
  field :answer_id, type: Moped::BSON::ObjectId
  field :question_id, type: Moped::BSON::ObjectId

  attr_accessible :id, :response, :user_id, :answer_id, :question_id, :compile_errors, :results

  belongs_to :user

  before_save :verify_response

  def answer
    @answer ||= Answer.find(self.answer_id)
  end

  def question_json
    @question_json ||= answer.super_exercise['questions'].select {|question| question['id'] == self.question_id}[0]
  end

  def question
    @question ||= Question.new(question_json)
  end

private
  def verify_response
    question = Question.find(self.question_id)
    compile_errors = ""
    correct = Hash.new
    self.results = Hash.new
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
        if $?.exitstatus == 0
          `diff /tmp/#{tmp}-output_response-#{t.id}.dat /tmp/#{tmp}-output-#{t.id}.dat`
        end
        correct[t.id] = $?.exitstatus
      end

      self.correct = true
      correct.each do |id,r|
        if not r == 0
          self.correct = false
          self.results[id] = Hash.new
          self.results[id][:error] = false
          self.results[id][:time] = false
          if r == 1
            self.results[id][:error] = true
          elsif r == 143
            self.results[id][:time] = true
          end
          self.results[id][:content] = question.test_cases.find(id).content
          self.results[id][:tip] = question.test_cases.find(id).tip
        end
      end
    end

    #la = LastAnswer.find_or_create_by(:user_id => self.user_id, :question_id => self.question_id)
    #self.try_number = 1
    #if not la.answer_id.nil?
    #  self.try_number = la.answer.try_number + 1
    #end
  end
end
