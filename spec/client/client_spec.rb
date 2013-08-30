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
      before(:all) do
        Thread.new { @server.run }
      end

      it 'sends test message to server and waits for response' do
        TEST_TIMEOUT = 2
        test_question = { type: :notice,
                         needs_response: true,
                         timeout: TEST_TIMEOUT,
                         body: 'Test message' }
        question_time = Time.now
        answer = @client.ask_server test_question
        (Time.now - question_time).should be <= TEST_TIMEOUT
        @client.last_question.should == test_question
        answer.should_not be_nil

        # Wait for response
        send_time = Time.now
        while true
          if test_question[:response]
            break
          end

          if Time.now - send_time > TEST_TIMEOUT
            break
          end
        end

        test_message[:response].should_not be_nil
      end
    end
  end
end
