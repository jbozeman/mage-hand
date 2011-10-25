require 'test/helper'

class TestBase < Test::Unit::TestCase
  context 'the Base class' do    
    should 'use the attr_simple method to add an attribute' do
      MageHand::Base.attr_simple :test_attribute, :second_attribute
      @instance = MageHand::Base.new
      @instance.test_attribute = 'Hello'
      @instance.second_attribute = 'World'
      assert_equal 'Hello', @instance.test_attribute
      assert_equal 'World', @instance.second_attribute
    end
    
    should 'be able to get a list of simple attributes' do
      MageHand::Base.attr_simple :test_attribute, :second_attribute
      @instance = MageHand::Base.new
      
      assert MageHand::Base.simple_attributes.include?(:test_attribute)
      assert @instance.simple_attributes.include?(:test_attribute)
      
      assert MageHand::Base.simple_attributes.include?(:second_attribute)
      assert @instance.simple_attributes.include?(:second_attribute)
    end
    
    should 'have id as a simple attribute' do
      assert MageHand::Base.simple_attributes.include?(:id)
    end
  end
end