class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable, :recoverable
  devise :database_authenticatable, :registerable,
	 :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :default => ''
  field :encrypted_password, :type => String, :default => ''

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  index({ email: 1 }, { unique: true, background: true })

  field :name, :type => String
  field :gravatar
  field :admin, :type => Boolean, default: false
  field :prof, :type => Boolean, default: false
  field :super_admin, :type => Boolean, default: false
  field :guest, :type => Boolean, default: false
  field :show_help, :type => Boolean, default: true

  attr_accessible :id, :name, :email, :password, :password_confirmation, :remember_me, :guest, :prof

  validates_presence_of :name

  before_save :do_gravatar_hash

  has_many :los, dependent: :delete
  has_many :answers, dependent: :delete
  has_many :retroaction_answers, dependent: :delete
  has_many :last_answers, dependent: :delete
  has_many :tags, dependent: :delete
  has_many :messages, dependent: :delete
  has_and_belongs_to_many :teams
  has_many :replies, dependent: :delete
  has_many :recommendations, dependent: :delete

  def do_gravatar_hash
    self.gravatar= Digest::MD5.hexdigest(self.email)
  end

  def question_overview(team,question)
    r = Answer.where(user_id: self.id, team_id: team.id, question_id: question.id, correct: true).last
    if r.nil?
      r = Answer.where(user_id: self.id, team_id: team.id, question_id: question.id).last
    end
   # [r,Answer.where(user_id: self.id, team_id: team.id, question_id: question.id).count]
  	[r,Answer.where(user_id: self.id, team_id: team.id, question_id: question.id).count,Comment.where(target_user_id: self.id, question_id:question.id).count]
  end

  def self.guest
    @user ||= User.where(email: 'guest@farma.mat.br').first
    return @user
  end


  def all_teams
    if self.admin?
      Team.all.asc(:name)
    else
      teams = Team.where(owner_id: self.id).asc('name') + self.teams.asc('name')
    end
  end

  def all_team_ids
    if self.admin?
      Team.all.pluck(:id)
    else
      teams = Team.where(owner_id: self.id).pluck(:id)
    end
  end

  def all_questions
    if self.admin?
      Question.all.asc(:title)
    else
      answered_questions = Answer.where(user_id:self.id).desc("question_id").distinct("question_id")
      questions = []
      unless answered_questions.empty?
	questions = Question.find(answered_questions)
      end

      question_ids = []
      for lo in self.all_los
	for ex in lo.exercises
	  question_ids = question_ids + ex.question_ids
	end
      end

      questions = questions + Question.find(question_ids)
      questions.uniq{|x| x.id}.sort_by{|x| x.title}
    end
  end

  def all_los
    if self.admin?
      Lo.all.asc(:name)
    else
      los = Array.new
      for team in self.all_teams do
	lo_ids = Answer.where(team_id:team.id).desc("lo_id").distinct("lo_id")
	if lo_ids.empty?
	  los = los + team.los
	else
	  los = los + (Lo.find(lo_ids) | team.los)
	end
      end

      if self.prof?
	los += self.los
      end

      los.uniq{|x| x.id}.sort_by{:name}
    end
  end

  def all_students
    if self.admin?
      User.all.asc(:name)
    else
      users = [self]
      for team in Team.where(owner_id: self.id).asc('name') do
	users = users + team.users
      end

      users.uniq{|x| x.id}.sort_by{:name}
    end
  end

  def all_tags
    #if self.admin?
      Tag.all.asc(:name)
    #else
    #  self.tags.asc(:name)
    #end
  end

  def number_of_new_messages
    Message.any_of(:new_flag_user_ids => self.id).count + self.messages.keep_if {|x| x['new_flag_user_id'] }.count
  end

	def messages_to_me
	  #@messages = Message.where(:target_user_ids => self.id).desc(:updated_at)
	@messages = Message.any_of({:target_user_ids => self.id}, {:user_ids => self.id.to_s}).desc(:updated_at)
	end

	def last_messages_to_me(n)
	  @messages = Message.any_of({:target_user_ids => self.id}, {:user_ids => self.id.to_s}).desc(:updated_at).desc(:updated_at).to_a + self.messages.keep_if {|x| x['new_flag_user_id'] }
	  @messages.sort { |x,y| y.updated_at <=> x.updated_at}
	end


	def is_message_new?(m)
	  m.new_flag_user_ids.include?(self.id) or (m.user_id == self.id and m.new_flag_user_id)
	end

	def link_to_question(q)
	  self.teams.each do |t|
	    t.los.each do |lo|
	      for i in 0..lo.exercises.length-1 do
	        e = lo.exercises[i]
	        if e.question_ids.include?(q.id)
	          return "/published/teams/#{t.id}/los/#{lo.id}/pages/#{i+1+lo.introductions.count}"
	        end
	      end
	    end
	  end
	  return nil
	end


	def progress_question(team_id,question_id)
	correct = Answer.where(user_id: self.id, question_id:question_id, correct: true).count > 0 ? true : false
if correct
return 1
else
	  Progress.find_or_initialize_by(team_id:team_id,user_id:self.id,question_id:question_id).value
end
	end

	def progress_lo(team_id,lo_id)
	  exercises = Lo.find(lo_id).exercises

	  progress = 0.0
	  n = 0
	  exercises.each do |ex|
	    ex.questions.each do |q|
	      progress = progress + self.progress_question(team_id,q.id)
	      n = n+1
	    end
	  end

	  unless n != 0
	    return 0.0
	  end

	  progress/n
	end

	def progress_team(team_id)
	  team = Team.find(team_id)

	  progress = 0.0
	  n = 0
	  team.los.each do |lo|
	    progress = progress + self.progress_lo(team_id,lo.id)
	    n = n+1
	  end

	  unless n != 0
	    return 0.0
	  end

	  progress/n
	end

	def last_try
	  Answer.where(:user_id => self.id).desc(:created_at).first
	end

	def questions_without_tries()
	  questions = []

	  self.teams.each do |t|
	    t.los.each do |lo|
	      lo.exercises.each do |ex|
	        ex.questions.each do |q|
	          if self.progress_question(t.id,q.id) == 0.0
	            questions << [t,q]
	          end
	        end
	      end
	    end
	  end
	  questions
	end

	def super_admin?
	  if self.super_admin
	    return true
	  end
	  return false
	end

	def admin?
	  if self.super_admin or self.admin
	    return true
	  end
	  return false
	end

	def prof?
	  if self.super_admin or self.admin or self.prof
	    return true
	  end
	  return false
	end

	def student?
	  if self.prof? && (not self.admin?)
	    return false
	  end
	  return true
	end
end

