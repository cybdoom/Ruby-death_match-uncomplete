require_relative 'command'

module Deathmatch
  module Common
    class CommandProcessor
      include Deathmatch::Common::Logger

      attr_reader :known_commands

      def initialize options={}
        @known_commands = options[:known_commands] || {}
      end

      def parse str
        name = ''
        args = []

        # Separate command
        i = 0
        while i < str.length && ![' ', "\n"].include?(str[i])
          name += str[i]
          i += 1
        end

        # Parse args
        if i < str.length
        end

        unless @known_commands[name.to_sym]
          log({
            type: :error,
            text: "Unknown command: #{name}"
          })

          nil
        else
          Common::Command.new({
            name: name,
            args: args,
            target: @known_commands[name.to_sym][:target],
            needs_response: @known_commands[name.to_sym][:needs_response]
          })
        end
      end
    end
  end
end
