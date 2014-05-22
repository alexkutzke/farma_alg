class ProcessQueue
  include Mongoid::Document
  include Mongoid::Timestamps

  field :type
  field :priority, type: Integer, default: 9
  field :params, type: Array, default: []


  def do_process
  	p = self
 
  	case p.type

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

  	self.delete

  	return true
  end

  def self.start
  	while true
  		while ProcessQueue.count > 0
  			p = ProcessQueue.asc(:priority,:created_at).first
  			p.do_process
  		end
  		puts "sleeping ..."
  		sleep 1
  	end
  end
end
