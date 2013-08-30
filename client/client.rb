require 'thread'

require_relative '../common/logger/logger'
require_relative '../common/network_connection/client_adapter'

module Deathmatch
  class Client
    include Deathmatch::Common::Logger
    include Deathmatch::Common::NetworkConnection::ClientAdapter

    attr_reader :network_initialized
    attr_reader :current_command
    attr_reader :status
    attr_reader :last_question

    ROOT = File.join(Dir.pwd, 'client')
    ACCEPT_COMMAND_TAKT = 0.1

    def initialize options
      action_result = init_network({ mode: options[:mode] })
      @network_initialized = action_result
      @status = action_result ? :ok : :error
    end

    private

    def accept_command
      raise NotImplementedError
    end

    def init_network options
      load_network_settings({ mode: options[:mode] })
      connect_to_server
    end
  end
end
