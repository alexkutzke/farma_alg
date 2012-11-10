class Lo
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String
  field :available, type: Boolean, default: false

  attr_accessible :id, :name, :description, :available

  validates_presence_of :name, :description
  validates :name, uniqueness: true
  validates :available, :inclusion => {:in => [true, false]}

  belongs_to :user
  has_many :introductions, dependent: :delete
  has_many :exercises, dependent: :delete
  has_and_belongs_to_many :teams

  def pages
    self.introductions_avaiable + self.exercises_avaiable
  end

  def pages_count
    self.pages.size
  end

  def pages_with_name
    i, e, page_count = 0, 0, 0

    self.pages.map do |page|
      if page.instance_of? Introduction
        i += 1
        page_count = i
      else
        e += 1
        page_count = e
      end
      { page_name: "#{page.class.model_name.human} #{page_count}: #{page.title}",
        type: page.class.to_s.downcase,
        page_collection: page_count-1
      }
    end
  end

  def exercises_avaiable
    self.exercises.where(available: true)
  end

  def introductions_avaiable
    self.introductions.where(available: true)
  end

end
