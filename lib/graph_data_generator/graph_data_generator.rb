module GraphDataGenerator

  def self.question_tries_x_time(question_id, method)
    answers = Answer.where(question_id:question_id).asc("created_at")
    final = []
    case method
    when "daily"
      date_string = "%d/%m/%Y"
    when "monthly"
    else
      date_string = "%m/%Y"
    end
    
    as = answers.group_by{|a| a.created_at.strftime(date_string)}
    as.each do |k,v|
      final << {"y" => k,"#{question_id}" => v.count}
    end

     final
  end
end