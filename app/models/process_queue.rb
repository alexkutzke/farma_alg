class ProcessQueue
  include Mongoid::Document
  include Mongoid::Timestamps

  field :type
  field :priority, type: Integer, default: 9
  field :params, type: Array, default: []

  before_create :verify_repeat

  def verify_repeat
    unless ProcessQueue.where(type: self.type, params: self.params, priority: self.priority).count == 0
      return false
    end
    return true
  end

  def do_process
  	p = self

    self.delete

  	case p.type

    when "apply_primary_tags"
       puts "Process: apply_primary_tags(#{p.params[0]}) started ..."
       Answer.find(p.params[0]).apply_primary_tags
       puts "Process: apply_primary_tags(#{p.params[0]}) ended ..."

   	when "make_inner_connections"
  		puts "Process: make_inner_connections(#{p.params[0]}) started ..."
  		Answer.find(p.params[0]).make_inner_connections
  		puts "Process: make_inner_connections(#{p.params[0]}) ended ..."

  	when "make_outer_connections"
  		puts "Process: make_outer_connections(#{p.params[0]}) started ..."
  		Answer.find(p.params[0]).make_outer_connections
  		puts "Process: make_outer_connections(#{p.params[0]}) ended ..."

  	when "propagate_properties"
  		puts "Process: propagate_properties(#{p.params[0]}) started ..."
  		Answer.find(p.params[0]).propagate_properties
  		puts "Process: propagate_properties(#{p.params[0]}) ended ..."
  	else
  		puts "Process type unknown."
  		return false
  	end

  	return true
  end

  def self.start
  	while true
  		while ProcessQueue.count > 0
  			p = ProcessQueue.asc(:priority,:created_at).first
  			p.do_process
  		end
  		sleep 1
  	end
  end
end
