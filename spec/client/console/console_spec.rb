require 'spec_helper'

module Deathmatch
  describe Console do
    before(:each) do
      @server = Server.new({ mode: :test })
      @console = Console.new({ mode: :test })
    end

    it 'creates valid console instance for :test mode' do
      @console.network_initialized.should be_true
    end

    it 'emulates console input' do
    end

    after(:each) do
      @server.shutdown
    end
  end
end
