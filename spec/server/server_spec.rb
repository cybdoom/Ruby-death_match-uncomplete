require 'spec_helper'

module Deathmatch
  describe Server do
    it 'creates valid server instance for :test mode' do
      @server = Server.new :test
      @server.database_loaded.should be_true
      @server.core_loaded.should be_true
      @server.network_initialized.should be_true
      @server.shutdown
    end

    context 'Running server' do
      before(:all) do
        @server = Server.new :test
        Thread.new { @server.run }
      end

      it 'sets server status to :ok after start' do
        @server.status.should == :ok
      end
    end
  end
end
