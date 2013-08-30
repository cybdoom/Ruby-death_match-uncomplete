require 'mongoid'

require_relative '../common/logger/logger'
require_relative '../common/command_processor/command_processor'
require_relative '../common/network_connection/server_adapter'
require_relative 'data_model/user'


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

      @accepted_messages = []
      @messages = []
      @works = true
    end

    def run
      @mutex = Mutex.new
      @acception_loop = Thread.new {
        while true
          @mutex.synchronize { accept_messages }
          sleep ACCEPT_COMMAND_TAKT
        end
      }
      @processing_loop = Thread.new {
        while true
          @mutex.synchronize { parse_and_process_messages }
          sleep PROCESS_COMMAND_TAKT
        end
      }
      @status = :ok
      @processing_loop.join
    end

    def shutdown
      @tcp_server.shutdown
    end

    private

    def parse_and_process_messages
      while @messages.any?
        process_next parsed_message
      end
    end

    def parsed_message
      @messages.pop
    end

    def process_next message
      case message[:type]
        when :command
          new_command = Command.new(message[:body])
          execute new_command
          answer_with_json message[:from], { body: "Executed command: #{new_command}",
                                             uuid: message[:uuid] } if message[:needs_answer]
        else
          answer_with_json message[:from], { body: "Received message: #{message[:body]}\nTime: #{Time.now}",
                                             uuid: message[:uuid] } if message[:needs_answer]
      end
    end

    def accept_messages
      @messages = @accepted_messages
      @accepted_messages.clear
    end

    def load_core
      true
    end

    def init_database options
      Mongoid.load! "#{ ROOT }/config/mongoid.yml", options[:mode]
    end

    def init_network options
      load_network_settings({ mode: options[:mode] })
      start_listen_network
    end
  end
end
