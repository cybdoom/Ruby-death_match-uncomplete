require_relative 'command'

module Deathmatch::Common::CommandProcessor
  KNOWN_COMMANDS =
  [
    :do_nothing,
    :shutdown
  ]

  def execute command
    unless KNOWN_COMMANDS.include? command.name
      return false
    else
    end

    self.send command.name
  end

  private

  def do_nothing
  end

  def shutdown
  end
end
