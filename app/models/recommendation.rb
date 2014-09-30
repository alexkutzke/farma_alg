# encoding: utf-8
class Recommendation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :type
  field :item, type: Hash

  belongs_to :user

  def self.all_from(user_id)
    rs = Recommendation.where(user_id: user_id)

    final = []
    rs.each do |r|
      if r.item.has_key?('team_id')
        if Team.find(r.item['team_id']).active
          final << r
        end
      else
        final << r
      end
    end

    final
  end

  def self.all_from_team(user_id,team_id)
    rs = Recommendation.where(user_id: user_id)

    final = []
    rs.each do |r|
      if r.item.has_key?('team_id')
        if Team.find(r.item['team_id']).id == team_id
          final << r
        end
      else
        final << r
      end
    end

    final
  end

  def self.delete_active
    rs = Recommendation.all

    rs.each do |r|
      if r.item.has_key?(:team_id)
        if Team.find(r.item[:team_id]).active
          r.delete
        end
      else
        r.delete
      end
    end
  end
end
