module Deathmatch::Common::CommandProcessor
  class Command
    attr_reader :arguments
    attr_reader :name

    def initialize signature
      @name = signature[:name]
      @arguments = signature[:arguments]
    end
  end
end
