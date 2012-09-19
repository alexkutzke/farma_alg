collection @questions, object_root: false

attributes :id, :title, :content, :available

child(:tips) do
  attributes :id, :content, :number_of_tries
end
