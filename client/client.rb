require 'thread'

require_relative '../common/logger/logger'
require_relative '../common/network_connection/client_adapter'
require_relative '../common/command_processor'

module Deathmatch
  class Client
    include Deathmatch::Common::Logger
    include Deathmatch::Common::NetworkConnection::ClientAdapter

    attr_reader :network_initialized
    attr_reader :current_command
    attr_reader :status
    attr_reader :last_command
    attr_reader :last_result
    attr_reader :access_rights

    ROOT = File.join(Dir.pwd, 'client')
    ACCEPT_COMMAND_TAKT = 0.1

    def run
      @shutdown_signal = false

      while !@shutdown_signal
        to_do = accept_command

        if to_do
          @last_result = case to_do.target
            when :self
              execute to_do
            when :remote
              send_to_server to_do
          end

          @last_command = to_do
          show_last_result
        end
      end
    end

    def initialize options
      action_result = init_network({ mode: options[:mode] })
      @network_initialized = action_result
      @status = action_result ? :ok : :error
      @access_rights = options[:access_rights] || :guest
      init_command_processor
    end

    private

    def init_command_processor
      @command_processor = Common::CommandProcessor.new({
        known_commands: {
          shutdown: {
            target: :remote,
            needs_response: true
          },

          exit: {
            target: :self,
            needs_response: false
          }
        }
      })
    end

    def execute command
      self.method(command.name).call command.arguments
    end

    def accept_command
      raise NotImplementedError
    end

    def show_last_result
      raise NotImplementedError
    end

    def init_network options
      load_network_settings({ mode: options[:mode] })
      connect_to_server
    end

    def exit args
      @shutdown_signal = true
    end
  end
end
