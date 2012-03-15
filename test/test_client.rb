require 'helper'

class TestClient < Test::Unit::TestCase
  context "The Obsidian Portal client" do
    should "configure correctly with a key and secret" do
      assert_nothing_raised {MageHand::Client.set_app_keys('asdfasdf','asdfasdfasdfasdfasdf')} 
    end
    should "raise an exception when the app keys are not set" do
      assert_raise(MageHand::OAuthConfigurationError) do
        # @request_token = stub('request token')
        MageHand::Client.send(:reset_client)
        MageHand::get_client
      end
    end
  end
  
  context "An instance of the client" do
    setup do
      response = Net::HTTPResponse.new("1.1", 200, "")
      @request_token = stub('request token')
      @access_token = stub_everything('access token')
      @access_token.stubs(:token).returns('access_token')
      @access_token.stubs(:secret).returns('access_secret')
      Net::HTTPResponse.any_instance.stubs(:body).returns "{'hello' : 'world'}"
      @request_token.stubs(:get_access_token).returns(@access_token)
      OAuth::AccessToken.any_instance.stubs(:post).returns(response)
      OAuth::Consumer.any_instance.stubs(:get_request_token).returns(@request_token)
      
      MageHand::Client.send(:reset_client)
      MageHand::Client.set_app_keys('asdfasdf', 'asdfasdfasdfasdfasdf')  
    end
    should "be configured to use different urls for authentication and api access" do
      @client = MageHand::get_client(nil, nil, nil)
      assert @client.consumer.site =~ /api\.obsidianportal\.com/
      assert @client.consumer.request_token_url =~ /https:\/\/www\.obsidianportal\.com/
      assert @client.consumer.authorize_url =~ /https:\/\/www\.obsidianportal\.com/
      assert @client.consumer.access_token_url =~ /https:\/\/www\.obsidianportal\.com/
    end
    should "have a request_token, and not an access token, when authorizing" do
      @client = MageHand::get_client(nil, nil, nil)
      assert_not_nil @client
      assert_equal @client.request_token, @request_token
      assert_nil @client.access_token
    end
    should "create an access_token when an oauth_verifier and request_token is passed in" do
      @client = MageHand::get_client(@request_token, nil, nil, nil, {:oauth_verifier => 'asdfasdf'})
      assert_not_nil @client
      assert_not_nil @client.access_token
      assert @client.logged_in?
    end
    should "be logged in if initialized with an access_key and access_secret" do
      @client = MageHand::get_client(nil, 'asdf', 'asdfasdfasdfasdf')
      assert_not_nil @client
      assert @client.logged_in?
      assert_equal @client.access_token.token, 'asdf'
      assert_equal @client.access_token.secret, 'asdfasdfasdfasdf'
    end
  end
end
