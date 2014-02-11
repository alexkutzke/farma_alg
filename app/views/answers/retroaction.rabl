glue @answer do
  attributes :id, :created_at, :response, :try_number, :lang

  node(:answered_by) { |answer| answer.user.name }
  node(:created_at) { |answer| l answer.created_at }

  node(:lo) {|answer| answer.lo.name}
  node(:team) {|answer| answer.team.name}
  node(:exercise) {|answer| answer.exercise_as_json}
  node(:question) {|answer| answer.question_as_json(current_user.id)}
  node(:user_id) {|answer| answer.user_id}

  child(:comments) do
    attributes :id
    node(:can_destroy) { |comment| comment.created_at >= 15.minutes.ago && comment.user_id == current_user.id  }
    node(:created_at_in_words) { |comment|  time_ago_in_words(comment.created_at) }
    node(:user_name) {|comment| comment.user.name }
    node(:user_gravatar) {|comment| comment.user.gravatar }
    node(:text) { |comment| markdown(comment.text) }
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
        previous: las[i+1].response,
        lang: la.lang,
        results: la.results,
        compile_errors: la.compile_errors,
        correct: la.correct
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
        previous: "",
        lang: la.lang,
        results: la.results,
        compile_errors: la.compile_errors,
        correct: la.correct
      }
      i = i+1
    end
  end
  result
end
end
