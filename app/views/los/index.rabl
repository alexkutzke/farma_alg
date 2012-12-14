collection @los, object_root: false
attributes :id, :name, :description, :available

node(:created_by) { |lo| lo.user.name }

node(:created_at) { |lo| l lo.created_at }
node(:updated_at) { |lo| l lo.updated_at }
