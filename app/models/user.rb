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
  field :super_admin, :type => Boolean, default: false
  field :guest, :type => Boolean, default: false

  attr_accessible :id, :name, :email, :password, :password_confirmation, :remember_me, :guest

  validates_presence_of :name

  before_save :do_gravatar_hash

  has_many :los, dependent: :delete
  has_many :answers, dependent: :delete
  has_many :retroaction_answers, dependent: :delete
  has_many :last_answers, dependent: :delete
  has_many :tags, dependent: :delete
  has_and_belongs_to_many :teams

  def do_gravatar_hash
    self.gravatar= Digest::MD5.hexdigest(self.email)
  end

  def question_overview(team,question)
    r = Answer.where(user_id: self.id, team_id: team.id, question_id: question.id, correct: true).last
    if r.nil?
      r = Answer.where(user_id: self.id, team_id: team.id, question_id: question.id).last
    end
    [r,Answer.where(user_id: self.id, team_id: team.id, question_id: question.id).count]
  end

  def self.guest
    @user ||= User.where(email: 'guest@farma.mat.br').first
    return @user
  end


  def all_teams
    if self.admin?
      Team.all
    else
      teams = Team.where(owner_id: self.id).asc('name') + self.teams.asc('name')
    end
  end

  def all_questions
    if self.admin?
      Question.all
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
      questions.uniq{|x| x.id}
    end
  end

  def all_los
    if self.admin?
      Lo.all
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
      
      los.uniq{|x| x.id}
    end
  end

  def all_students
    if self.admin?
      User.all
    else
      users = [self]
      for team in Team.where(owner_id: self.id).asc('name') do
        users << team.users
      end

      users.uniq{|x| x.id}
    end
  end

  def all_tags
    if self.admin?
      Tag.all
    else
      self.tags
    end
  end
end
