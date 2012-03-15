require 'helper'

class TestMageHandUser < Test::Unit::TestCase
  class User
    include MageHandUser
    attr_accessor :access_token_key, :access_token_secret, :saved
    @saved = false
    def save!
      @saved = true
    end
  end
  
  context 'The Mage Hand User Module' do
    should 'be able to save op authorization tokens' do
      user = User.new
      assert !user.saved
      user.save_op_tokens('abcdefg', '1234567')
      assert user.saved
      assert_equal 'abcdefg', user.access_token_key
      assert_equal '1234567', user.access_token_secret
    end
  end
end