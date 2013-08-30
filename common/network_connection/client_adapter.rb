module Deathmatch::Common::NetworkConnection
  module ClientAdapter
    require 'socket'
    require 'yaml'
    require 'thread'
    require 'json'

    def ask_server question
      @server_socket.puts question
      @last_question = question
      @server_socket.gets
    end

    private

    def connect_to_server
      begin
        @server_socket = TCPSocket.open(@network_config[:host], @network_config[:port])
        true
      rescue
        false
      end
    end

    def load_network_settings options
      File.open("#{ Deathmatch::Client::ROOT }/config/network.yml", 'r') do |file|
        @network_config = (YAML.load file)[options[:mode]]
      end

      true
    end
  end
end
