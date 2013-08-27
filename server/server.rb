require 'mongoid'

require_relative '../common/logger/logger'
require_relative '../common/command_processor/command_processor'
require_relative '../common/network_connection/server_adapter'

module Deathmatch
  class Server
    require 'thread'

    include Deathmatch::Common::Logger
    include Deathmatch::Common::CommandProcessor
    include Deathmatch::Common::NetworkConnection::ServerAdapter

    attr_reader :database_loaded
    attr_reader :core_loaded
    attr_reader :network_initialized
    attr_reader :status

    ROOT = File.join(Dir.pwd, 'server')
    PROCESS_COMMAND_TAKT = 0.01
    ACCEPT_COMMAND_TAKT = 0.1

    def initialize mode
      action_result = init_database mode
      @database_loaded = action_result
      @status = action_result ? :ok : :error

      action_result = load_core
      @core_loaded = action_result
      @status = :error unless action_result

      action_result = init_network mode
      @network_initialized = action_result
      @status = :error unless action_result

      @accepted_commands = []
      @command_queue = []
      @works = true
    end

    def run
      @mutex = Mutex.new
      @acception_loop = Thread.new {
        while true
          @mutex.synchronize { accept_commands }
          sleep ACCEPT_COMMAND_TAKT
        end
      }
      @execution_loop = Thread.new {
        while true
          @mutex.synchronize { execute_commands }
          sleep PROCESS_COMMAND_TAKT
        end
      }
      @status = :ok
      @execution_loop.join
    end

    def shutdown
      @tcp_server.shutdown
    end

    private

    def execute_commands
      @command_queue << Command.new({ name: :do_nothing })
      while @command_queue.any?
        execute_next
      end
    end

    def accept_commands
      @command_queue = @accepted_commands
      @accepted_commands.clear
    end

    def load_core
      true
    end

    def init_database mode
      Mongoid.load! "#{ ROOT }/config/mongoid.yml", mode
      require_relative 'data_model/user'
    end

    def init_network mode
      load_network_settings mode
      start_listen_for_connections
    end
  end
end
