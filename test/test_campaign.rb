require 'helper'

class TestCampaign < Test::Unit::TestCase
  context 'the Campaign class' do
    setup do
      @mini_fields = {
        :id => 'asdf12341asdf1234',
        :name => 'Fellowship of the Ring',
        :campaign_url => 'http://www.obsidianportal.com/campaigns/fellowship-of-the-ring',
        :visibility => 'public',
        :role => 'player'
      }
      @full_fields = @mini_fields.merge(
        :slug => 'FotR',
        :play_status => 'active',
        :looking_for_players => false
      )
    end
    
    should 'be able to initialize from a mini object' do
      campaign = MageHand::Campaign.new(nil, @mini_fields)
      assert_not_nil campaign
      @mini_fields.each do |key, value|
        assert_equal campaign.send(key), value
      end
    end
    
    should 'be able to initialize from a complete object' do
      campaign = MageHand::Campaign.new(nil, @full_fields)
      assert_not_nil campaign
      @full_fields.each do |key, value|
        assert_equal campaign.send(key), value
      end     
    end
  end

  context 'A Campaign instance' do
    setup do
      @mini_fields = {
        :id => 'asdf12341asdf1234',
        :name => 'Fellowship of the Ring',
        :campaign_url => 'http://www.obsidianportal.com/campaigns/fellowship-of-the-ring',
        :visibility => 'public',
        :role => 'player'
      }
    end

    should 'report title case player role' do
      campaign = MageHand::Campaign.new(nil, @mini_fields)
      assert_equal 'Player', campaign.humanized_role
      assert_equal campaign.humanized_role, campaign.role_as_title_string, 'Deprecated role_as_title_string should produce the same result.'
      campaign.role = 'game_master'
      assert_equal 'Game Master', campaign.humanized_role
      assert_equal campaign.humanized_role, campaign.role_as_title_string, 'Deprecated role_as_title_string should produce the same result.'
    end

    context 'with wiki pages' do
      setup do
        @campaign = MageHand::Campaign.new(nil, @mini_fields)
        @page_array = [
          MageHand::WikiPage.new(nil, {id: 'asdfadf0', type: 'WikiPage'}),
          MageHand::WikiPage.new(nil, {id: 'asdfadf1', type: 'Post', post_time: '2008-04-24T22:00:00Z'}),
          MageHand::WikiPage.new(nil, {id: 'asdfadf2', type: 'WikiPage'}),
          MageHand::WikiPage.new(nil, {id: 'asdfadf3', type: 'Post', post_time: '2007-04-24T22:00:00Z'})
          ]
        MageHand::WikiPage.expects(:load_wiki_pages).with(@campaign).returns(@page_array)
      end

      should 'be able to return its wiki pages and adventure logs' do\
        assert_equal 4, @campaign.all_wiki_pages.count, 'should have 4 pages total'
      end

      should 'return just the adventure logs' do
        assert_equal 2, @campaign.posts.count, 'should have 2 posts'
        assert_equal 'asdfadf3', @campaign.posts.first.id
        assert_equal 'asdfadf1', @campaign.posts.last.id
      end

      should 'return just the pages that are not adventure logs' do
        assert_equal 2, @campaign.wiki_pages.count, 'should have 2 pages'
        assert @campaign.wiki_pages.map(&:id).include?('asdfadf0')
        assert @campaign.wiki_pages.map(&:id).include?('asdfadf2')
      end
    end

    should 'know its location' do
      @mini_fields[:location] = {lat: 32.4567, lon: 75.4567}
      campaign = MageHand::Campaign.new(nil, @mini_fields)

      assert campaign.location.instance_of? MageHand::Location
      assert_equal @mini_fields[:location][:lat], campaign.location.lat
      assert_equal @mini_fields[:location][:lng], campaign.location.lng
    end

    should 'know its url' do
      id_string = 'asdf12341asdf1234'
      campaign = MageHand::Campaign.new(nil, :id => id_string)
      assert_equal "/v1/campaigns/#{id_string}.json", campaign.send(:individual_url)
    end
  end
end