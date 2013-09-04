require_relative '../client'

module Deathmatch
  class Console < Client
    PROMPT = 'DEATH_MATCH CONSOLE >>> '

    private

    def accept_command
      puts PROMPT
      gets
    end

    def parse message
      command = '', args = [], current_str

      # Separate command
      (0..message.length).each do |i|
        break if message[i] == ' '
        command += message[i]
        message = message.shift
      end
    end
  end
end
