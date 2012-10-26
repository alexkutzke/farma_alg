glue @answer do
  attributes :id, :created_at, :response, :try_number

  node(:answered_by) { |answer| answer.user.name }
  node(:created_at) { |answer| l answer.created_at }

  node(:lo) {|answer| answer.lo.name}
  node(:team) {|answer| answer.team.name}
  node(:exercise) {|answer| answer.exercise_as_json}
  node(:question) {|answer| answer.question_as_json}
end
