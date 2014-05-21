object @answer
attributes :id, :response, :correct, :try_number, :similar_answers
child(:user) { attributes :name }
child(:question) { attributes :title }