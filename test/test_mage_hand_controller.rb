require 'helper'
require 'active_support'
require 'active_support/test_case'
require 'action_controller'
require 'action_controller/test_case'

class UnderTestController < ActionController::Base
  include MageHandController
  def current_user
    
  end
end

class TestMageHandController < ActionController::TestCase
  tests UnderTestController
  
  context 'The Mage Hand Controller Module' do
    setup do
      MageHand::Client.set_app_keys('asdfasdf', 'asdfasdfasdfasdfasdf')
      stub_request(:post, "https://www.obsidianportal.com/oauth/request_token").
        to_return(:status => 200, :body => "", :headers => {})
    end
    
    should 'return an obsidian portal client' do
      assert @controller.send(:obsidian_portal).instance_of? MageHand::Client
    end
    
    should 'know if an op user is logged in' do
      assert !@controller.send(:logged_in_op?)
      
      @controller.send(:obsidian_portal).access_token_key = 'asdfasdf'
      @controller.send(:obsidian_portal).access_token_secret = 'adsfasdfasdfasdf'
      assert @controller.send(:logged_in_op?)
    end
    
    should 'be able to store tokens on the user and the session' do
      @controller.send(:obsidian_portal).access_token_key = 'asdfasdf'
      @controller.send(:obsidian_portal).access_token_secret = 'adsfasdfasdfasdf'
      assert @controller.send(:logged_in_op?)
    end
  end
end