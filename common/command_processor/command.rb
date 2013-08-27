module Deathmatch::Common::CommandProcessor
  class Command
    attr_reader :arguments
    attr_reader :name
    attr_reader :owner

    def initialize hash
      @name = hash[:name]
      @arguments = hash[:arguments]
      @owner = hash[:owner]
    end
  end
end
