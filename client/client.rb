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
    attr_reader :last_message
    attr_reader :access_rights

    ROOT = File.join(Dir.pwd, 'client')
    ACCEPT_COMMAND_TAKT = 0.1

    def run
      @shutdown_signal = false

      while !@shutdown_signal
        to_do = accept_command
        if to_do[:target] == :client
          send_to_server to_do[:body]
        elsif to_do[:target] == :server
          execute to_do[:body]
        end
      end
    end

    def initialize options
      action_result = init_network({ mode: options[:mode] })
      @network_initialized = action_result
      @status = action_result ? :ok : :error
      @access_rights = options[:access_rights] || :guest
    end

    private

    def execute message
      command, arguments = parse message
      self.send command, arguments
    end

    def parse message
      raise NotImplementedError
    end

    def accept_command
      raise NotImplementedError
    end

    def init_network options
      load_network_settings({ mode: options[:mode] })
      connect_to_server
    end

    def shutdown args
      @shutdown_signal = true
    end
  end
end
