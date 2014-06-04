object @answer
attributes :id, :response, :correct, :try_number, :similar_answers, :compile_errors
child(:user) { attributes :name }
child(:question) { attributes :title }
child :tags do
	attributes :id, :name, :description, :type
end