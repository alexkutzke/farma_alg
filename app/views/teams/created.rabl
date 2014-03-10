collection @teams, object_root: false

attributes :id, :name
node(:created_at) { |lo| l lo.created_at }
node(:numbers_of_enrolled) { |team| team.users.count }

child(:users) do
  attributes :name, :email, :id
end
