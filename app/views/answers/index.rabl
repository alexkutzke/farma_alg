object false

node(:total) {|m| @answers.total_count }
node(:total_pages) {|m| @answers.num_pages }

child @answers do
  attributes :id, :tip, :response, :try_number, :correct, :many_answers

  node(:team) {|an| an.team.name}
  node(:user_id) {|an| an.user.id}
  node(:user) {|an| an.user.name}
  node(:lo) {|an| an.lo.name}
  node(:exercise) {|an| an.exercise.title}
  node(:question) {|an| an.question.title}
  node(:many_answers) {|an| an.question.many_answers}
end