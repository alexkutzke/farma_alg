glue @answer do
  attributes :id, :created_at, :response, :try_number, :lang

  node(:answered_by) { |answer| answer.user.name }
  node(:created_at) { |answer| l answer.created_at }

  node(:lo) {|answer| answer.lo.name}
  node(:team) {|answer| answer.team.name}
  node(:exercise) {|answer| answer.exercise_as_json}
  node(:question) {|answer| answer.question_as_json}
  node(:user_id) {|answer| answer.user_id}

  child(:comments) do
    attributes :id
    node(:can_destroy) { |comment| comment.created_at >= 15.minutes.ago && comment.user_id == current_user.id  }
    node(:created_at_in_words) { |comment|  time_ago_in_words(comment.created_at) }
    node(:user_name) {|comment| comment.user.name }
    node(:user_gravatar) {|comment| comment.user.gravatar }
    node(:text) { |comment| markdown(comment.text) }
  end
end
