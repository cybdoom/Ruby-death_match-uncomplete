require 'mongoid'

require_relative '../common/logger/logger'

module Deathmatch
  class Server
    include Deathmatch::Common::Logger

    attr_accessor :database_loaded
    attr_accessor :core_loaded
    attr_accessor :network_initialized

    ROOT = File.join(Dir.pwd, 'server')

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
      while true
      end
    end

    private

    def load_core
      true
    end

    def init_database mode
      Mongoid.load! "#{ Deathmatch::Server::ROOT }/config/mongoid.yml", mode
      require_relative 'data_model/user'
      DataModel::User.new.save
    end

    def init_network
      false
    end
  end
end
