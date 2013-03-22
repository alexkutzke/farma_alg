#I had to override this method because object id wasn't serialized as a string but an object

module Moped
  module BSON
    class ObjectId
      def to_json(*args)
        to_s.to_json
      end
    end
  end
end
