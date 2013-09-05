require 'mongoid'
require 'json'

require_relative '../common/logger/logger'
require_relative '../common/network_connection/server_adapter'
require_relative '../common/command_processor'
require_relative 'data_model/user'


module Deathmatch
  class Server
    require 'thread'

    include Deathmatch::Common::Logger
    include Deathmatch::Common::NetworkConnection::ServerAdapter

    attr_reader :database_loaded
    attr_reader :core_loaded
    attr_reader :network_initialized
    attr_reader :status
    attr_reader :alive

    ROOT = File.join(Dir.pwd, 'server')
    PROCESS_COMMAND_TAKT = 0.01
    ACCEPT_COMMAND_TAKT = 0.1

    def initialize options
      action_result = init_database({ mode: options[:mode] })
      @database_loaded = action_result
      @status = action_result ? :ok : :error

      action_result = load_core
      @core_loaded = action_result
      @status = :error unless action_result

      action_result = init_network({ mode: options[:mode] })
      @network_initialized = action_result
      @status = :error unless action_result

      @alive = @status == :ok
      log({
        type: :notice,
        text: "Server was started"
      })
    end

    def shutdown
      @tcp_server.shutdown
      @alive = false
      true
    end

    def test_connection args
      STDOUT.puts 'The connection is ok'
    end

    private

    def load_core
      init_command_processor
    end

    def init_command_processor
      @command_processor = Common::CommandProcessor.new({
        known_commands: {
          shutdown: {
            target: :self,
            needs_response: true
          },

          test_connection: {
            target: :remote,
            needs_response: true
          }
        }
      })
    end

    def init_database options
      Mongoid.load! "#{ ROOT }/config/mongoid.yml", options[:mode]
    end

    def init_network options
      load_network_settings({ mode: options[:mode] })
      start_listen_network
    end

    def serve client
      @client = client

      while @alive
        str = client.gets
        incoming_command = (str != '') ? Common::Command.new(JSON.parse str) : nil
        if incoming_command
          result = execute(incoming_command)
          @client.puts result if result
        end

        sleep SERVE_CLIENT_TAKT
      end
    end

    def execute command
      # TODO: Fix dynamic call
      #self.method(command.name).call(command.arguments)
      shutdown
    end
  end
end
