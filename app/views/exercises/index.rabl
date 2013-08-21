collection @exercises, object_root: false

attributes :id, :title, :content, :available

child(:questions) do
  attributes :id, :title, :content, :available, :languages
end

node(:created_at) { |exer| l exer.created_at }
node(:updated_at) { |exer| l exer.updated_at }
