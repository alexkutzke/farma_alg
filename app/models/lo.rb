class Lo
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String
  field :available, type: Boolean, default: false

  attr_accessible :id, :name, :description, :available

  validates_presence_of :name, :description
  validates :available, :inclusion => {:in => [true, false]}

  belongs_to :user
  has_many :introductions, dependent: :delete
  has_many :exercises, dependent: :delete
end
