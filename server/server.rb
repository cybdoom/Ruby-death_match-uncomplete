require 'mongoid'
require 'json'

require_relative '../common/logger/logger'
require_relative '../common/network_connection/server_adapter'
require_relative '../common/command_processor/command_processor'
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
    end

    def shutdown
      @tcp_server.shutdown
    end

    private

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

    def serve client
      @client = client

      while true
        incoming_message = JSON.parse client.gets
        if incoming_message.to_s != ''
          response = process incoming_message
          client.puts response if response
        end

        sleep SERVE_CLIENT_TAKT
      end
    end

    def process message
      message['type'] == 'question' ? "Received message: #{message}\nFrom: #{@client}" : nil
    end
  end
end
