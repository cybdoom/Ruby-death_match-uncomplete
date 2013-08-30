module Deathmatch::Common::NetworkConnection
  module ClientAdapter
    require 'socket'
    require 'yaml'
    require 'thread'
    require 'json'
    require 'uuidtools'

    def load_network_settings options
      File.open("#{ Deathmatch::Client::ROOT }/config/network.yml", 'r') do |file|
        @network_config = (YAML.load file)[options[:mode]]
      end

      true
    end

    def ask_server question
      uuid = UUIDTools::UUID.timestamp_create

      question.merge!({ uuid: uuid.to_i })
      @server_socket.puts question
      @last_question = question
      @server_socket.gets
    end

    def connect_to_server
      begin
        @server_socket = TCPSocket.open(@network_config[:host], @network_config[:port])
        true
      rescue
        false
      end
    end

    private

    def accept_responses server
      responses = []
      while line = server.gets
        responses << line
      end

      responses.each do |response|
        parsed_hash = JSON.load response
        pending_messages[parsed_hash[:uuid]][:response] = parsed_hash[:body]
      end
    end
  end
end
