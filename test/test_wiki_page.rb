require 'helper'

class TestWikiPage < Test::Unit::TestCase
    context 'the WikiPage class' do
    setup do
      @mini_fields = {
        id: 'asdf12341asdf1234',
        name: 'History of Moria',
        wiki_page_url: 'http://www.obsidianportal.com/campaigns/wikis/history-of_moria',
        type: 'WikiPage',
        tags: ['moria', 'history'],
        created_at: '2007-04-24T21:42:13Z',
        updated_at: '2007-04-24T21:42:13Z',
        is_game_master_only: false,
        campaign: {
          id: '5b6ef1e0f24411dfba8140403656340d',
          name: 'Kensing',
          slug: 'kensing',
          campaign_url: 'http://www.obsidianportal.com/campaigns/kensing/wikis/main-page',
          banner_image_url: 'http://cdn.obsidianportal.com/foo/bar/image.jpg',
          visibility: 'public'
        }
      }
      @full_fields = @mini_fields.merge(
        :slug => 'FotR',
        :play_status => 'active',
        :looking_for_players => false
      )
    end
    
    should 'be able to initialize from a mini object' do
      wiki_page = MageHand::WikiPage.new(nil, @mini_fields)
      assert_not_nil wiki_page
      @mini_fields.each do |key, value|
        assert_equal wiki_page.send(key), value unless key == :campaign
      end
    end
    
    should 'be able to initialize from a complete object' do
      wiki_page = MageHand::WikiPage.new(nil, @full_fields)
      assert_not_nil wiki_page
      @full_fields.each do |key, value|
        assert_equal wiki_page.send(key), value
      end     
    end
  end
end