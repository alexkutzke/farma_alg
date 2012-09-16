collection @introductions, object_root: false

attributes :id, :title, :content, :available

node(:created_at) { |intro| l intro.created_at }
node(:updated_at) { |intro| l intro.updated_at }
