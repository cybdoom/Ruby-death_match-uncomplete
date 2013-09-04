module Deathmatch
  module Common
    module CommandProcessor
      class Command
        attr_reader :arguments
        attr_reader :name
        attr_reader :owner

        def initialize options={}
          @name = options[:name] || 'unnamed'
          @arguments = options[:arguments]
          @owner = options[:owner]
        end
      end
    end
  end
end
