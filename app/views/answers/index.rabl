object false

node(:total) {|m| @answers.total_count }
node(:total_pages) {|m| @answers.num_pages }

child @answers do
  attributes :id, :response, :try_number, :correct


  node(:created_at) {|an| l an.created_at}
  node(:team) {|an| an.team.name}
  node(:user_id) {|an| an.user.id}
  node(:user) {|an| an.user.name}
  node(:lo) {|an| an.lo.name}
  node(:exercise) {|an| an.exercise.title}
  node(:question) {|an| an.question.title}
end
