require 'helper'

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
    
    should 'be able to add an instance of another class as an attribute' do
      MageHand::Base.attr_instance :test_campaign, :class_name => 'Campaign'
      @instance = MageHand::Base.new
      @instance.test_campaign = {:name => "A Great Time"}
      assert_equal "A Great Time", @instance.test_campaign.name
    end
    
    should 'be able to get a list of instance attributes' do
      MageHand::Base.attr_instance :test_campaign, :class_name => 'Campaign'
      @instance = MageHand::Base.new
      
      assert MageHand::Base.instance_attributes.include?(:test_campaign)
      assert @instance.instance_attributes.include?(:test_campaign)
    end
    
    should 'be able to get a list of all declared attributes' do
      MageHand::Base.attr_instance :test_campaign, :class_name => 'Campaign'
      MageHand::Base.attr_simple :test_attribute
      @instance = MageHand::Base.new
      
      assert MageHand::Base.attributes.include?(:test_campaign)
      assert @instance.attributes.include?(:test_campaign)
      assert MageHand::Base.attributes.include?(:test_attribute)
      assert @instance.attributes.include?(:test_attribute)
    end
    
    should 'have id as a simple attribute' do
      assert MageHand::Base.simple_attributes.include?(:id)
    end    
  end
end