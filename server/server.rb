require 'mongoid'

require_relative '../common/logger/logger'
require_relative '../common/command_processor/command_processor'

module Deathmatch
  class Server
    require 'thread'

    include Deathmatch::Common::Logger
    include Deathmatch::Common::CommandProcessor

    attr_accessor :database_loaded
    attr_accessor :core_loaded
    attr_accessor :network_initialized

    ROOT = File.join(Dir.pwd, 'server')
    PROCESS_COMMAND_TAKT = 0.01
    ACCEPT_COMMAND_TAKT = 0.1

    def initialize mode
      action_result = init_database mode
      self.database_loaded = action_result
      action_result = load_core
      self.core_loaded = action_result
      action_result = init_network
      self.network_initialized = action_result

      @accepted_commands = []
      @command_queue = []
    end

    def run
      @mutex = Mutex.new
      @main_loop_thread = Thread.new {
        while true
          @mutex.synchronize { execute_commands }
          sleep PROCESS_COMMAND_TAKT
        end
      }
      @command_processor_thread = Thread.new {
        while true
          @mutex.synchronize { accept_commands }
          sleep ACCEPT_COMMAND_TAKT
        end
      }
    end

    def send_command command
      @accepted_commands << command
    end

    private

    def execute_commands
      while @command_queue.any?
        execute_command @command_queue.pop
      end
    end

    def accept_commands
      puts 'In accept_command method'
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
