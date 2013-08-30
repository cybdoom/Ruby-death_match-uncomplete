module Deathmatch::Common::NetworkConnection
  module ServerAdapter
    require 'socket'
    require 'yaml'
    require 'thread'

    ACCEPT_CONNECTION_TAKT = 0.01

    def load_network_settings options
      File.open("#{ Deathmatch::Server::ROOT }/config/network.yml", 'r') do |file|
        @network_config = (YAML.load file)[options[:mode]]
      end
    end

    def start_listen_network
      @tcp_server = TCPServer.new @network_config[:question_port]
      @connected_clients = []
      @listening_loop = Thread.new {
        while true
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

    def answer_with_json client, question
      begin
        @remote_socket = TCPSocket.open(client[:host], client[:answer_port])
        @remote_socket.puts JSON.dump(question)
        @remote_socket.close
        @last_sent = json_message
        @pending_messages[uuid] = @last_sent if json_message[:needs_response]
        return true
      rescue
        return false
      end
    end

    private

    def serve client
      while true
        client.puts(client.gets)
      end
    end
  end
end
