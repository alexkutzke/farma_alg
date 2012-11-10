collection @introductions, object_root: false

attributes :id, :title, :content, :available, :position

node(:created_at) { |intro| l intro.created_at }
node(:updated_at) { |intro| l intro.updated_at }
