collection @teams, object_root: false

attributes :id, :name

node(:enrolled) do |team|
  current_user.teams.include?(team)
end

node(:created_by) { |team| team.owner.name }
node(:created_at) { |team| l team.created_at }
