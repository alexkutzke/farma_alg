collection @comments, object_root: false

attributes :id,:target_user_id, :text, :user_id, :team_id, :question_id

node(:user_name) { current_user.name }
node(:question_title) { |c| Question.find(c.question_id).title }
node(:team_name) { |c| Team.find(c.team_id).name }
node(:user_gravatar) { current_user.do_gravatar_hash }
node(:created_at_in_words) {|c| time_ago_in_words c.created_at}
node(:lo_id) {|c| c.answer.lo_id}
node(:answer_id) {|c| c.answer.id}