# encoding: utf-8
class Reply
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content

  validates_presence_of :content,:message => "A mensagem precisa ter algum conteúdo"

  belongs_to :user
  belongs_to :message

  after_create :check_message_as_new, :send_mail

  def check_message_as_new
    m = self.message
    m.new_flag_user_ids = m.user_ids
    m.new_flag_user_id = true
    m.save
  end

  def send_mail
    user_ids = self.message.user_ids
    user_ids << self.message.user_id.to_s
    user_ids.delete(self.user_id.to_s)
    user_ids.uniq!

    User.find(user_ids).each do |u|
      MessageMailer.reply_received(self,self.message,u).deliver
    end
  end
end
