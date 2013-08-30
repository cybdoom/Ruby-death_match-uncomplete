require 'spec_helper'

module Deathmatch
  describe Server do
    before(:each) do
      @server = Server.new({ mode: :test })
    end

    after(:each) do
      @server.shutdown
    end

    it 'creates valid server instance for :test mode' do
      @server.database_loaded.should be_true
      @server.core_loaded.should be_true
      @server.network_initialized.should be_true
      @server.status.should be_true
    end

    it 'runs server' do
      Thread.new { @server.run }
      @server.status.should be_true
    end
  end
end
