module GraphDataGenerator

  def self.date_string(method)
    case method
    when "daily"
      date_string = "%Y-%m-%d"
    when "monthly"
      date_string = "%Y-%m"
    else
      date_string = "%Y"
    end
  end

  def self.group_by_time(answers,method,id)
    final = []
    case method
    when "daily"
      date_string = "%Y-%m-%d"
    when "monthly"
      date_string = "%Y-%m"
    else
      date_string = "%Y"
    end

    as = answers.group_by{|a| a.created_at.strftime(date_string)}
    as.each do |k,v|
      final << {"y" => k,"#{id}" => v.count}
    end

     final
  end

  def self.question_tries_x_time(team_id,question_id, method)
    answers = Answer.where(team_id:team_id, question_id:question_id)
                    .asc("created_at")
                    .chunk{|n| n.created_at.strftime(self.date_string(method))}
                    .to_a
  end

  def self.team_tries_x_time(team_id, lo_id, method)
    answers = Answer.where(team_id:team_id, lo_id:lo_id)
                    .asc("created_at")
                    .chunk{|n| n.created_at.strftime(self.date_string(method))}
                    .to_a
  end


  def self.team_tries_x_time(team_id, method)
    final = []
    Answer.where(team_id:team_id)
                    .asc("created_at")
                    .chunk{|n| n.created_at.strftime(self.date_string(method))}
                    .each do |q,a|
                      final << {"date" => q, "value" => a.count}
                    end
    final

    final2 = []
    final.each do |data|
      if final2.empty?
        final2 << data
      else
        while final2.last["date"] < data["date"] do
          final2 << {"date" => (Date.strptime(final2.last["date"], self.date_string(method))+1).strftime(self.date_string(method)), "value" => 0}
        end

        final2 << data
      end
    end

    final2
  end

  def self.team_recent_activity(team_id)
    final = {}
    method = "daily"
    Answer.where(team_id:team_id).limit(500)
                    .desc("created_at")
                    .chunk{|n| n.created_at.strftime(self.date_string(method))}
                    .each do |q,a|
                      final.merge! Date.strptime(q, self.date_string(method)).to_time.to_i.to_s => a.count
                    end
    final
  end

  def self.team_user_recent_activity(team_id, user_id)
    final = {}
    method = "daily"
    Answer.where(team_id:team_id,user_id: user_id)
                    .asc("created_at")
                    .chunk{|n| n.created_at.strftime(self.date_string(method))}
                    .each do |q,a|
                      final.merge! Date.strptime(q, self.date_string(method)).to_time.to_i.to_s => a.count
                    end
    final
  end

  def self.team_user_lo_recent_activity(team_id, user_id, lo_id)
    final = {}
    method = "daily"
    Answer.where(team_id:team_id,user_id: user_id,lo_id:lo_id)
                    .asc("created_at")
                    .chunk{|n| n.created_at.strftime(self.date_string(method))}
                    .each do |q,a|
                      final.merge! Date.strptime(q, self.date_string(method)).to_time.to_i.to_s => a.count
                    end
    final
  end

  # def self.team_lo_tries(team_id)
  #   final = []
  #
  #   Team.find(team_id).lo_ids.each do |lo_id|
  #     tries = Answer.where(team_id:team_id,lo_id:lo_id).count
  #     final << {lo_name:Lo.find(lo_id).name,tries:tries, subs: [{a:"a",v:10},{a:"b",v:20}]}
  #   end
  #   final
  # end

  def self.team_lo_tries(team_id)
    final = []

    Team.find(team_id).lo_ids.each do |lo_id|
      tries = Answer.where(team_id:team_id,lo_id:lo_id).count
      name = Lo.find(lo_id).name
      final << {name:name, short_name:"..."+name.last(8),y:tries}
    end
    final
  end


  def self.team_user_lo_tries(team_id,user_id)
    final = []

    Team.find(team_id).lo_ids.each do |lo_id|
      tries = Answer.where(team_id:team_id,lo_id:lo_id,user_id:user_id).count
      name = Lo.find(lo_id).name
      final << {name:name, short_name:"..."+name.last(8),y:tries}
    end
    final
  end
end
