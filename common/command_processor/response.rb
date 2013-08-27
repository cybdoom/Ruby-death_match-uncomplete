module Deathmatch::Common::CommandProcessor
  class Response
    attr_reader :type
    attr_reader :data

    def initialize hash
      @type = hash[:type]
      @data = hash[:data]
    end
  end
end
