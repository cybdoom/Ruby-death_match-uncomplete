require_relative '../client'

module Deathmatch
  class Console < Client
    PROMPT = 'DEATH_MATCH CONSOLE >>> '

    private

    def accept_command
      puts PROMPT
      gets
    end
  end
end
