require 'spec_helper'

module Deathmatch
  describe Client do
    before(:all) do
      @server = Server.new :test
    end

    after(:all) do
      @server.shutdown
    end

    it 'does nothing' do
    end
  end
end
