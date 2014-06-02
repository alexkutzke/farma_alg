require 'math_evaluate'
require 'judge'

include ActionView::Helpers::TextHelper

class Answer

  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include MathEvaluate
  include Judge


  field :response
  field :changed_correctness, type: Boolean, default: false
  field :changed_correctness_reason
  field :correct, type: Boolean
  field :results, type: Hash
  field :for_test, type: Boolean
  field :retroaction, type: Boolean, default: false
  field :compile_errors
  field :try_number, type: Integer
  field :lang

  field :automatically_assigned_tags, type: Array, default: []
  field :rejected_tags, type: Array, default: []

  field :lo, type: Hash
  field :exercise, type: Hash
  field :question, type: Hash
  field :team, type: Hash

  field :team_id, type: Moped::BSON::ObjectId
  field :lo_id, type: Moped::BSON::ObjectId
  field :exercise_id, type: Moped::BSON::ObjectId
  field :question_id, type: Moped::BSON::ObjectId


  search_in :response, :compile_errors, :user => :name, :question => :title, :question => :content

  alias :super_exercise :exercise
  alias :super_question :question

  attr_accessible :id, :response, :user_id, :team_id, :lo_id, :exercise_id, :question_id, :for_test, :try_number, :results, :lang, :retroaction

  belongs_to :user
  has_one :last_answer
  #embeds_many :comments, :as => :commentable
  has_many :comments
  has_many :connections, dependent: :delete
  has_and_belongs_to_many :tags

  #default_scope desc(:created_at)

  scope :wrong, where(correct: false, :team_id.ne => nil, :for_test.ne => true)
  scope :corrects, where(correct: true, :team_id.ne => nil, :for_test.ne => true)
  scope :every, excludes(team_id: nil, for_test: true)

  #before_save :verify_response, :store_datas
  before_create :verify_response, :store_datas
  after_create :register_last_answer,:updateStats,:schedule_process_connections #, :update_questions_with_last_answer

  #def self.search(page, params = nil, team_ids = nil)
  #  if team_ids
  #    if params
  #      Answer.excludes(team_id: nil, for_test: true).where(params).in(team_id: team_ids).page(page).per(20)
  #    else
  #      Answer.excludes(team_id: nil, for_test: true).in(team_id: team_ids).page(page).per(20)
  #    end
  #  else
  #    if params
  #      Answer.excludes(team_id: nil, for_test: true).where(params).page(page).per(20)
  #    else
  #      Answer.excludes(team_id: nil, for_test: true).page(page).per(20)
  #    end
  #  end
  #end

  def similar_answers
    sa = []
    self.connections.each do |c|
      sa << c.target_answer_id
    end

    sa
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
      question['answered'] = question['_id'] == self.question_id
      if question['answered']
        question['last_answer'] = self.as_json
        %w(updated_at exercise lo question team created_at).each {|e| question['last_answer'].delete(e)}
      end
      #else
      #  x = LastAnswer.find_or_create_by(:user_id => self.user_id, :question_id => question['_id'])
      #  if x.answer_id.nil?
      #    question['last_answer'] = nil
      #    x.delete
      #  else
      #    question['last_answer'] = Answer.find(x.answer_id).as_json
      #    %w(updated_at exercise lo question team created_at).each {|e| question['last_answer'].delete(e)}
      #  end
      #end
      %w(position available lo_id updated_at test_cases correct_answer created_at).each {|e| question.delete(e)}
    end
    exercises['questions'].delete_if {|question| not question['answered']}
    exercises
  end

  def question
    @_question ||= Question.new(super) rescue nil
  end

  def question_as_json(user_id)
    question = super_question
    %w(position available lo_id updated_at test_cases exercise_id correct_answer).each {|e| question.delete(e)}
    #question['last_answer']['last_answers'] = Answer.where(user_id: user_id, question_id:question['id']).desc(:created_at).first.as_json
    #question['last_answer']['last_answers'].delete('los_ids')
    #question['last_answer']['last_answers'].delete('question')
    #question['last_answer']['last_answers'].delete('exercise')
    #question['last_answer']['last_answers'].delete('lo')
    #question['last_answer']['last_answers'].delete('team')
    question
  end

  def team
    @_team ||= Team.new(super) rescue nil
  end

# Need store all information for retroaction

  def store_datas
    question = Question.find(self.question_id)
    self.exercise = question.exercise.as_json(include: {questions: {include: :test_cases }})
    self.lo = question.exercise.lo.as_json
    self.question = question.as_json(include: :test_cases)
    self.team = Team.find(self.team_id).as_json if self.team_id
  end

  def exec
    question = Question.find(self.question_id)
    tmp = Time.now.to_i

    compile_result = Judge::compile(self.lang,self.response,tmp)

    if compile_result[0] != 0
      self.compile_errors = compile_result[1]
      self.correct = false      
    else

      correct = Judge::test(lang,compile_result[1],question.test_cases,tmp)
      
      self.results = Hash.new
      self.correct = true
      correct.each do |id,r|

        self.results[id] = Hash.new
        self.results[id][:error] = false
        self.results[id][:diff_error] = false
        self.results[id][:time_error] = false
        self.results[id][:exec_error] = false
        self.results[id][:presentation_error] = false
        self.results[id][:content] = question.test_cases.find(id).content
        self.results[id][:tip] = question.test_cases.find(id).tip
        self.results[id][:title] = question.test_cases.find(id).title
        self.results[id][:show_input_output] = question.test_cases.find(id).show_input_output

        if question.test_cases.find(id).show_input_output
          self.results[id][:input] = r[1][0]
          self.results[id][:output_expected] = r[1][1]
        end

        self.results[id][:output] = r[1][2]
        self.results[id][:id] = id

        if r[0] == 3 
          self.correct = false
          self.results[id][:error] = true
          self.results[id][:diff_error] = true
        elsif r[0] == 2
          self.correct = false
          self.results[id][:error] = true
          self.results[id][:presentation_error] = true
        elsif r[0] == 143
          self.correct = false
          self.results[id][:error] = true
          self.results[id][:time_error] = true
        elsif r[0] != 0
          self.correct = false
          self.results[id][:error] = true
          self.results[id][:exec_error] = true
        end

        #self.results[id][:output2] = simple_format r[1][0]
      end
    end
  end

  def available_tags
    available_tags = []
    Tag.all.each do |t|
      available_tags << t.name
    end

    tags = []
    self.tags.each do |t|
      tags << t.name
    end

    available_tags - tags
  end

  def verify_response
    
    self.exec

    unless self.for_test
      la = LastAnswer.find_or_create_by(:user_id => self.user_id, :question_id => self.question_id)
      self.try_number = 1
      if not la.answer_id.nil?
        self.try_number = la.answer.try_number + 1
      else
        la.delete
      end
    end
  end

  def updateStats
    global_stat = Statistic.find_or_create_by(:question_id => self.question_id, :team_id => nil)

    team_stat = Statistic.find_or_create_by(:question_id => self.question_id, :team_id => self.team_id)

    global_stat.updateStats(self)
    team_stat.updateStats(self)

    global_stat.save!
    team_stat.save!
  end

  def previous(n)
    previous_answers = Answer.where(user_id: self.user_id, team_id: self.team_id, question_id: self.question_id).desc(:created_at).lte(created_at: self.created_at)[0..n]

    x = previous_answers.count
    if x > 0
      i = 0
      while i < x - 1
        previous_answers[i]['previous'] = previous_answers[i+1].response.clone
        puts i
        puts previous_answers[i]['previous']
        i = i + 1
      end
      previous_answers[i]['previous'] = ""
    end

    previous_answers
  end

  def propagate_properties
    queue = []
    visited = []

    queue.push self.id
    visited.push self.id

    while not queue.empty?
      answer_id = queue.shift

      answer = Answer.find(answer_id)

      for similar_answer in answer.similar_answers do
        unless visited.include?(similar_answer)
          queue.push similar_answer
          visited.push similar_answer
        end

        neigh = Answer.find(similar_answer)
        connections = neigh.connections
        weight = connections[connections.index{|x| x.target_answer_id.to_s == answer.id.to_s}].weight
        naat = neigh.automatically_assigned_tags

        # confirmed tags
        for tag in answer.tags do
          # neigh already has this tag as confirmed
          if neigh.tags.include?(tag)
            # do nothing
          # neigh already has this tag as automatically assigned
          elsif not (i = naat.index{ |x| x[0].to_s == tag.id.to_s }).nil?
            t = naat[i]

            # passed by another answer
            if t[2] != answer.id
              if t[1] < weight
                t[1] = weight
              end
            # passed by this answers  
            else
              # update anyway
              t[1] = weight
            end
          # neigh does not have this tag
          else
            # was it rejected?
            unless neigh.rejected_tags.include?(tag.id.to_s)
              naat.push [tag.id,weight,answer.id]
            end
          end
        end

        # automatically assigned tags
        for atag in answer.automatically_assigned_tags do
          tag = Tag.find(atag[0])

          # neigh already has this tag as confirmed
          if neigh.tags.include?(tag)
            # do nothing
          # neigh already has this tag as automatically assigned
          elsif not (i = naat.index{ |x| x[0].to_s == tag.id.to_s }).nil?
            t = naat[i]

            # passed by another answer
            if t[2] != answer.id
              if t[1] < weight*atag[1]
                t[1] = weight*atag[1]
              end
            # passed by this answers  
            else
              # update anyway
              t[1] = atag[1] * weight
            end
          # neigh does not have this tag
          else
            unless neigh.rejected_tags.include?(tag.id.to_s)
              naat.push [tag.id,weight*atag[1],answer.id]
            end
          end
        end

        for rejected in answer.rejected_tags do
          unless (i = naat.index{ |x| x[2].to_s == answers.id.to_s && x[0].to_s == rejected.to_s }).nil?
            naat.delete_at(i)
          end
        end

        neigh.save!

      end
    end
    true
  end

  def schedule_process_connections
    ProcessQueue.create(:type => "make_inner_connections", 
                        :priority => 2,
                        :params => [self.id])
    ProcessQueue.create(:type => "make_outer_connections", 
                        :priority => 5,
                        :params => [self.id])
  end

  def schedule_process_propagate
    ProcessQueue.create(:type => "propagate_properties", 
                        :priority => 2,
                        :params => [self.id])
  end

  def make_inner_connections
    per_batch = 1000

    inner_neigh = Answer.where(:question_id => self.question_id)

    0.step(inner_neigh.count, per_batch) do |offset|
      inner_neigh.limit(per_batch).skip(offset).each do |a| 
        if self.id != a.id
          SimilarityMachine::create_connection(self,a)
        end
      end
    end

    true
  end

  def make_outer_connections
    per_batch = 1000

    outer_neigh = Answer.where(:question_id.ne => self.question_id)

    0.step(outer_neigh.count, per_batch) do |offset|
      outer_neigh.limit(per_batch).skip(offset).each do |a| 
        if self.id != a.id
          SimilarityMachine::create_connection(self,a)
        end
      end
    end

    true
  end

private

  def register_last_answer
    unless self.for_test
      la = LastAnswer.find_or_create_by(:user_id => self.user.id, :question_id => self.question.id)
      la.answer = self
      la.question = self.question
      la.user = self.user
      la.save!
    end
  end

  def self.search(params,user)
    if params.has_key?(:query) and params[:query].empty?
      if params.has_key?(:daterange) and params[:daterange].empty?
        if not params.has_key?(:user_ids) and
          not params.has_key?(:team_ids) and
          not params.has_key?(:lo_ids) and
          not params.has_key?(:question_ids) and
          not params.has_key?(:answer_ids) and
          not params.has_key?(:tag_ids)
          return []
        end
      end
    end


    as = Answer.excludes(team_id: nil, for_test: true)

    if params.has_key?(:query) and not params[:query].empty?
      as = as.full_text_search(params[:query], match: :all)
    end

    if params.has_key?(:daterange) and not params[:daterange].empty?
      start_date = DateTime.strptime(params[:daterange].split(" - ").first,"%d/%m/%Y %H:%M").change(:offset => "-0300")
      end_date = DateTime.strptime(params[:daterange].split(" - ").last,"%d/%m/%Y %H:%M").change(:offset => "-0300")

      as = as.gte(:created_at => start_date)
      as = as.lte(:created_at => end_date)
    end

    if params.has_key?(:user_ids)
      as = as.in(user_id: params[:user_ids])
    end

    if params.has_key?(:team_ids)
      as = as.in(team_id: params[:team_ids])
    end

    if params.has_key?(:lo_ids)
      as = as.in(lo_id: params[:lo_ids])
    end

    if params.has_key?(:question_ids)
      as = as.in(question_id: params[:question_ids])
    end

    if params.has_key?(:answer_ids)
      as = as.in(id: params[:answer_ids])
    end

    if params.has_key?(:tag_ids)
      as = as.in(tag_ids: params[:tag_ids])
    end

    unless user.admin?
      user_ids = []
      for u in user.all_students do
        user_ids << u.id
      end
      as = as.in(user_id: user_ids)
      
      team_ids = []
      for t in user.all_teams do
        team_ids << t.id
      end
      as = as.in(team_id: team_ids)

      lo_ids = []
      for l in user.all_los do
        lo_ids << l.id
      end
      as = as.in(lo_id: lo_ids)

      question_ids = []
      for q in user.all_questions do
        question_ids << q.id
      end
      as = as.in(question_id: question_ids)

      if params.has_key?(:tag_ids)
        tag_ids = []
        for t in user.all_tags do
          tag_ids << t.id
        end
        as = as.in(tag_ids: tag_ids)
      end
    end

    as
  end

  def self.re_run(user_ids)
    user_ids.each do |u|
      p User.find(u).name
      Answer.where(user_id:u).each do |a|
        unless a.for_test
          a.exec
          a.store_datas
          a.save!
        end
      end
    end

    Statistic.delete_all
    Answer.all.each do |a|
      a.updateStats
    end
  end
end
