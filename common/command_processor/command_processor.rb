require_relative 'command'

module Deathmatch::Common::CommandProcessor
  KNOWN_COMMANDS =
  [
    :do_nothing,
    :shutdown
  ]

  def execute_next
    execute(@command_queue.pop)
  end

  private

  def execute command
    unless KNOWN_COMMANDS.include? command.name
      return false
    else
    end

    self.send command.name
  end

  def do_nothing
  end

  def shutdown
  end
end
