require 'spec_helper'
require 'thread'

module Deathmatch
  describe Client do
    before(:each) do
      @server = Server.new({ mode: :test })
      @client = Client.new({ mode: :test })
    end

    after(:each) do
      @server.shutdown
    end

    it 'creates valid client instance for :test mode' do
      @client.network_initialized.should be_true
    end

    context 'Interaction with server' do
      it 'asks server the test question' do
        TEST_TIMEOUT = 0.1
        test_question = { type: :question,
                          timeout: TEST_TIMEOUT,
                          body: 'Test message' }
        question_time = Time.now
        answer = @client.send_to_server test_question
        (Time.now - question_time).should be <= TEST_TIMEOUT
        @client.last_message.should == test_question
        answer.should_not be_nil
      end
    end
  end
end
