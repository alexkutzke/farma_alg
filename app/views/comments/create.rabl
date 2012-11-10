glue @comment do
  attributes :id
end
node(:can_destroy) { true }
node(:text) {  markdown(@comment.text) }
node(:created_at_in_words) {   time_ago_in_words(@comment.created_at) }
node(:user_name) { @comment.user.name }
node(:user_gravatar) { @comment.user.gravatar }
