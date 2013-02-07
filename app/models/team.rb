#encoding: utf-8
class Team
  include Mongoid::Document
  include Mongoid::Timestamps

  field :code, :type => String
  field :name, :type => String
  field :owner_id, :type => Moped::BSON::ObjectId

  attr_accessible :name, :code, :owner_id, :lo_ids

  has_and_belongs_to_many :los
  has_and_belongs_to_many :users

  validates_presence_of :name, :code
  validates_uniqueness_of :name

  # Return scope not the records
  def self.search(search)
    if search
      any_of(:name => /.*#{search}.*/i).desc(:created_at)
    else
      all.desc(:created_at)
    end
  end

  def owner
    @owner ||= User.find(self.owner_id)
  end

  def enroll(user, code)
    if code == self.code
      self.errors.messages.delete :enroll
      unless self.users.include?(user)
        self.users << user
        self.save
      end
      return true
    else
      self.errors.messages[:enroll] = [I18n.translate('mongoid.errors.messages.invalid')]
      return false
    end
  end
end
