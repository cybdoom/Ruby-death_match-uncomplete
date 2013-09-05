require_relative '../client'

module Deathmatch
  class Console < Client
    PROMPT = 'DEATH_MATCH CONSOLE >>> '

    private

    def accept_command
      printf PROMPT
      @command_processor.parse STDIN.gets
    end

    def show_last_result
      puts "Executed command: #{@last_command.name}\nResults: #{@last_result}"
    end
  end
end
