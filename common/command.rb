module Deathmatch
  module Common
    class Command
      attr_reader :arguments
      attr_reader :name
      attr_reader :target
      attr_reader :needs_response

      def initialize options={}
        new_options = {}
        options.each_pair do |key, value|
          new_options[key.to_sym] = value
        end
        options = new_options
        @name = options[:name] || 'unnamed'
        @arguments = options[:arguments]
        @target = options[:target]
        @needs_response = options[:needs_response] || false
      end

      def to_s
        puts "Name: #{@name}\nArguments: #{@arguments}\nTarget: #{@target}\nNeeds response: #{@needs_response}"
      end

      def to_hash
        {
          name:             @name,
          arguments:        @arguments,
          target:           @target,
          needs_response:   @needs_response
        }
      end
    end
  end
end
