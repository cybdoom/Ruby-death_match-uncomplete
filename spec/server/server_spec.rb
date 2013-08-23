require 'spec_helper'
require_relative '../../server/server'

module Deathmatch
  describe Server do
    before(:all) do
      @server = Server.new :test
    end

    it 'initializes database connection' do
      @server.database_loaded.should be_true
    end

    it 'checks if logic core was successfully loaded' do
      @server.core_loaded.should be_true
    end

    it 'ititializes network connection' do
      @server.network_initialized.should be_true
    end
  end
end
