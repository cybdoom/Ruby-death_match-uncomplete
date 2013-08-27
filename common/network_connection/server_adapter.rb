module Deathmatch::Common::NetworkConnection
  module ServerAdapter
    require 'socket'
    require 'yaml'
    require 'thread'

    ACCEPT_CONNECTION_TAKT = 0.01

    def load_network_settings mode
      File.open("#{ Deathmatch::Server::ROOT }/config/network.yml", 'r') do |file|
        @network_config = (YAML.load file)[mode]
      end
    end

    def start_listen_for_connections
      @tcp_server = TCPServer.new @network_config[:port]
      Thread.new {
        while true
          Thread.start(@tcp_server.accept) do |client|
            serve @tcp_server.accept
          end

          client.close
          sleep ACCEPT_CONNECTION_TAKT
        end
      }

      true
    end

    private

    def serve client
    end
  end
end
