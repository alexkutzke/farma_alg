class Statistic
  include Mongoid::Document
  include Mongoid::Timestamps

  field :correctness_rate, type: Float, default: 0.0
  field :correct_tries, type: Integer, default: 0
  field :wrong_tries, type: Integer, default: 0
  field :compile_error, type: Integer, default: 0
  field :team_id, type: String
  field :test_case_results, type: Hash

  attr_accessible :id, :correctness_rate, :team_id, :question_id, :test_case_results

  belongs_to :question

public
  def updateStats(answer)
    # init test_case_results variables
    self.test_case_results = Hash.new if self.test_case_results.nil?
    unless answer.results.nil?
      answer.results.each do |id,t|
        self.test_case_results["#{id}"] = Hash.new if self.test_case_results["#{id}"].nil?
        self.test_case_results["#{id}"]['wrong_tries'] = 0 if self.test_case_results["#{id}"]['wrong_tries'].nil?
        self.test_case_results["#{id}"]['correct_tries'] = 0 if self.test_case_results["#{id}"]['correct_tries'].nil?
        self.test_case_results["#{id}"]['title'] = t[:title]
      end
    end

    if answer.correct
      self.correct_tries = self.correctness_rate + 1
      answer.results.each do |id,t|
        self.test_case_results["#{id}"]['correct_tries'] = self.test_case_results["#{id}"]['correct_tries'] + 1
        self.test_case_results["#{id}"]['correctness_rate'] = self.test_case_results["#{id}"]['correct_tries'].to_f / (self.test_case_results["#{id}"]['correct_tries'].to_f + self.test_case_results["#{id}"]['wrong_tries'].to_f)
      end
    else
      self.wrong_tries = self.wrong_tries + 1

      if answer.compile_errors.nil?
        answer.results.each do |id,t|
          if t[:diff_error] or t[:presentation_error] or t[:time_error] or t[:exec_error] 
            self.test_case_results["#{id}"]['wrong_tries'] = self.test_case_results["#{id}"]['wrong_tries'] + 1
          else
            self.test_case_results["#{id}"]['correct_tries'] = self.test_case_results["#{id}"]['correct_tries'] + 1
          end
          self.test_case_results["#{id}"]['correctness_rate'] = self.test_case_results["#{id}"]['correct_tries'].to_f / (self.test_case_results["#{id}"]['correct_tries'].to_f + self.test_case_results["#{id}"]['wrong_tries'].to_f)
        end
      else
        self.compile_error = self.compile_error + 1
      end
    end

    self.correctness_rate = self.correct_tries.to_f / (self.correct_tries.to_f + self.wrong_tries.to_f)


  end
end
