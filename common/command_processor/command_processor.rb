require_relative 'command'

module Deathmatch::Common::CommandProcessor
  KNOWN_COMMANDS =
  [
    :do_nothing,
    :shutdown
  ]

  def command_queue
    @command_queue || []
  end

  def execute_next
    execute(command_queue.pop || Command.new({ name: :do_nothing }))
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
    log({ type: :warning,
          text: 'Shutdown command detected. Closing all...'})
  end
end
