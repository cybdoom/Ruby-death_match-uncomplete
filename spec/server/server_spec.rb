require 'spec_helper'
require_relative '../../server/server'

module Deathmatch
  describe Server do
    before(:all) do
      @server = Server.new :test
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
      before(:all) do
        Thread.new { @server.run }
      end

      it 'has status :ok after run started' do
        @server.status.should == :ok
      end
    end
  end
end
