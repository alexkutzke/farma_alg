glue @answer do
  attributes :id, :team_id, :response, :try_number, :correct, :compile_errors, :results, :question_id, :lang
end

node :last_answers do
  las = @last_answers
  result = {}
  i = 0
  if las.length > 1
    las[0..-2].each do |la|
  	  result[i.to_s] = 
    	{
      	id: las[i].id,
      	response: las[i].response,
      	created_at: time_ago_in_words(las[i].created_at),
      	previous: las[i+1].response 
    	}
    	i = i+1
    end
  else
   	las.each do |la|
  	  result[i.to_s] = 
    	{
      	id: las[i].id,
      	response: las[i].response,
      	created_at: time_ago_in_words(las[i].created_at),
      	previous: ""
    	}
    	i = i+1
    end
  end
  result
end