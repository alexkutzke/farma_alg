# encoding: utf-8
class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :subject
  field :content
  field :new_flag_user_id, type: Boolean, default: false
  field :target_user_ids, type: Array, default: []
  field :user_ids, type: Array, default: []
  field :new_flag_user_ids, type: Array, default: []
  field :team_ids, type: Array, default: []
  field :answer_ids, type: Array, default: []
  field :question_ids, type: Array, default: []

  validates_presence_of :target_user_ids, :message => "Pelo menos um destinatário precisa ser informado"
  validates_presence_of :subject,:message => "A mensagem precisa ter um assunto"
  validates_presence_of :content,:message => "A mensagem precisa ter algum conteúdo"

	belongs_to :user
  has_many :replies, dependent: :delete
  after_create :send_mail

  def has_recommendation?
    ((not self.answer_ids.nil?) and (not self.answer_ids.empty?)) || ((not self.question_ids.nil?) and (not self.question_ids.empty?))
  end

  def can_post?(user)
    (self.user_id == user.id) or (self.target_user_ids.include?(user.id)) or (self.user_ids.include?(user.id.to_s))
  end

  def send_mail
    user_ids = self.target_user_ids

    User.find(user_ids).each do |u|
      MessageMailer.message_received(self,u).deliver
    end
  end
end
