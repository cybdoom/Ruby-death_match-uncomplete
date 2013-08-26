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
    PROCESS_COMMAND_TAKT = 1000

    def initialize mode
      log ({ type: :notice,
             text: 'Initializing database...' })
      action_result = init_database mode
      self.database_loaded = action_result
      log ({ type: (action_result ? :notice : :error),
             text: (action_result ? 'Done' : 'Failed') })
      log ({ type: :notice,
             text: 'Initializing core...' })
      action_result = load_core
      self.core_loaded = action_result
      log ({ type: (action_result ? :notice : :error),
             text: (action_result ? 'Done' : 'Failed') })
      log ({ type: :notice,
             text: 'Initializing network...' })
      action_result = init_network
      self.network_initialized = action_result
      log ({ type: (action_result ? :notice : :error),
             text: (action_result ? 'Done' : 'Failed') })
    end

    def run
      log ({ type: :notice,
             text: "Starting main loop..."})

      @mutex = Mutex.new
      @main_loop_thread = Thread.new {
        while true
          @mutex.synchronize { execute_commands }
          Threed.sleep PROCESS_COMMAND_TAKT
        end
      }
      @command_processor_thread = Thread.new {
        while true
          @mutex.synchronize { accept_commands }
          Thread.sleep 10
        end
      }
    end

    def send_command argument
      log({ type: :debug,
            text: "Accepted command: #{argument}"})
      command_queue.unshift Command.new(argument)
    end

    private

    def load_core
      true
    end

    def init_database mode
      Mongoid.load! "#{ ROOT }/config/mongoid.yml", mode
      require_relative 'data_model/user'
      DataModel::User.new.save
    end

    def init_network
      true
    end
  end
end
