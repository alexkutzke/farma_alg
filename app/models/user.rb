class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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
  field :guest, :type => Boolean, default: false

  attr_accessible :id, :name, :email, :password, :password_confirmation, :remember_me, :guest

  validates_presence_of :name

  before_save :do_gravatar_hash

  has_many :los, dependent: :delete
  has_many :answers, dependent: :delete
  has_many :retroaction_answers, dependent: :delete
  has_many :last_answers, dependent: :delete
  has_and_belongs_to_many :teams

  def do_gravatar_hash
    self.gravatar= Digest::MD5.hexdigest(self.email)
  end

  def self.guest
    @user ||= User.where(email: 'guest@farma.mat.br').first
    return @user
  end
end
