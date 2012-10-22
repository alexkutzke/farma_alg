collection @los, object_root: false

attributes :id

node(:label) {|t| t.name}
node(:value) {|t| t.name}
