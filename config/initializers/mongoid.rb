#Mongoid.add_language("pt-br")
module Mongoid
  module BackboneSerialization
    extend ActiveSupport::Concern

    module InstanceMethods
      def serializable_hash(options = nil)
        persisted? ? super.merge('id' => _id) : super
      end
    end
  end
end

module Mongoid
  module Document
    def as_json(options={})
      attrs = super(options)
      attrs['id'] = self.persisted? ? self._id : nil;
      attrs
    end
  end
end
