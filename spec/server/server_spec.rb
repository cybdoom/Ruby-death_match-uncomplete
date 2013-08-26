require 'spec_helper'
require_relative '../../server/server'

module Deathmatch
  describe Server do
    before(:all) do
      @server = Server.new :test
    end

    after(:all) do
      @server.send_command({ name: :shutdown })
    end

    context 'Creates simple test server.' do
      it 'initializes database connection' do
        @server.database_loaded.should be_true
      end

      it 'loads logic core successfully' do
        @server.core_loaded.should be_true
      end

      it 'ititializes network connection' do
        @server.network_initialized.should be_true
      end
    end

    context 'Runs simple test server' do
      it 'is in main loop after run' do
        Thread.new { @server.run }
      end
    end
  end
end
