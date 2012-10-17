object false

node(:total) {|m| @teams.total_count }
node(:total_pages) {|m| @teams.num_pages }

child @teams do
  object false

  attributes :id, :name
  node(:enrolled) do |team|
    current_user.teams.include?(team)
  end

  node(:created_by) { |team| team.owner.name }
  node(:created_at) { |team| l team.created_at }
end
