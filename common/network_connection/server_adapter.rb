module Deathmatch::Common::NetworkConnection
  module ServerAdapter
    require 'socket'
    require 'yaml'
    require 'thread'

    ACCEPT_CONNECTION_TAKT = 0.01
    SERVE_CLIENT_TAKT = 0.01

    private

    def load_network_settings options
      File.open("#{ Deathmatch::Server::ROOT }/config/network.yml", 'r') do |file|
        @network_config = (YAML.load file)[options[:mode]]
      end
    end

    def start_listen_network
      @tcp_server = TCPServer.new @network_config[:question_port]
      @connected_clients = []
      @listening_loop = Thread.new {
        while @alive
          Thread.start(@tcp_server.accept) do |client|
            @connected_clients << client
            serve client
            client.close
          end

          sleep ACCEPT_CONNECTION_TAKT
        end
      }

      true
    end
  end
end
