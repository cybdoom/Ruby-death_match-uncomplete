require_relative 'command'

module Deathmatch
  module Common
    module CommandProcessor
      KNOWN_COMMANDS =
      [
        :shutdown
      ]

      def execute command
        return unless KNOWN_COMMANDS.include? command.name
      end
    end
  end
end
