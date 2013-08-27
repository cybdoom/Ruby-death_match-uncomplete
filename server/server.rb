require 'mongoid'

require_relative '../common/logger/logger'
require_relative '../common/command_processor/command_processor'

module Deathmatch
  class Server
    require 'thread'

    include Deathmatch::Common::Logger
    include Deathmatch::Common::CommandProcessor

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

      action_result = init_network
      @network_initialized = action_result
      @status = :error unless action_result

      @accepted_commands = []
      @command_queue = []
    end

    def run
      @mutex = Mutex.new
      @command_processor_thread = Thread.new {
        while true
          @mutex.synchronize { accept_commands }
          sleep ACCEPT_COMMAND_TAKT
        end
      }
      @main_loop_thread = Thread.new {
        while true
          @mutex.synchronize { execute_commands }
          sleep PROCESS_COMMAND_TAKT
        end
      }.join
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

    def init_network
      true
    end
  end
end
