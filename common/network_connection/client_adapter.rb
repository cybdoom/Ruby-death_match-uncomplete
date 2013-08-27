module Deathmatch::Common::NetworkConnection
  module ClientAdapter
    require 'socket'
    require 'yaml'
    require 'thread'

    def load_network_settings mode
      File.open("#{ Deathmatch::Client::ROOT }/config/network.yml", 'r') do |file|
        @network_config = (YAML.load file)[mode]
      end

      true
    end

    def test_connection
      @socket = TCPSocket.open(@network_config[:host], @network_config[:port])
      while line = @socket.gets
        puts line
      end
      @socket.close
    end
  end
end
