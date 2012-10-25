collection @exercises, object_root: false

attributes :id

node(:label) {|t| t.title}
node(:value) {|t| t.title}
