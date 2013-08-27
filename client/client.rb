require_relative '../common/logger/logger'
require_relative '../common/network_connection/client_adapter'

module Deathmatch
  class Client
    include Deathmatch::Common::Logger
    include Deathmatch::Common::NetworkConnection::ClientAdapter

    attr_reader :network_initialized

    ROOT = File.join(Dir.pwd, 'client')

    def initialize mode
      action_result = init_network mode
      @network_initialized = action_result
    end

    private

    def init_network mode
      load_network_settings mode
    end
  end
end
