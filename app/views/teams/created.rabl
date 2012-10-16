collection @teams, object_root: false

attributes :id, :name
node(:created_at) { |lo| l lo.created_at }
