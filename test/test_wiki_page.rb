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
          :body => 'Moria is a _deep_ mine.',
          :body_html => '<p>Moria is a <em>deem</em> mine.</p>',
          :post_title => 'The first session',
          :post_tagline => 'A great adventure'
        )
      end
    
    should 'be able to initialize from a mini object' do
      wiki_page = MageHand::WikiPage.new(nil, @mini_fields)
      assert_not_nil wiki_page
      @mini_fields.each do |key, value|
        assert_equal wiki_page.send(key), value unless key == :campaign
      end

      @mini_fields[:campaign].each do |key, value|
        assert_equal wiki_page.campaign.send(key), value
      end
    end
    
    should 'be able to initialize from a complete object' do
      wiki_page = MageHand::WikiPage.new(nil, @full_fields)
      assert_not_nil wiki_page
      @full_fields.each do |key, value|
        assert_equal wiki_page.send(key), value unless key == :campaign
      end     
    end
  end

  context 'A WikiPage instance' do
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
          name: 'Fellowship of the Ring',
          slug: 'FoTR',
          campaign_url: 'http://www.obsidianportal.com/campaigns/kensing/wikis/main-page',
          banner_image_url: 'http://cdn.obsidianportal.com/foo/bar/image.jpg',
          visibility: 'public'
        }
      }
      @wiki_page = MageHand::WikiPage.new(nil, @mini_fields)
    end
    should 'know if it is an adventure log post or not' do
      assert_equal 'WikiPage', @wiki_page.type
      assert !@wiki_page.is_post?

      @wiki_page.type = 'Post'
      assert_equal 'Post', @wiki_page.type
      assert @wiki_page.is_post?
    end

    should 'be able to instantiate its campaign from string or symbol keys' do
      assert_equal 'Fellowship of the Ring', @wiki_page.campaign.name

      @wiki_page.campaign = {'name' => 'The Two Towers'}
      assert_equal 'The Two Towers', @wiki_page.campaign.name
    end

    should 'respond to is_game_master_only?' do
      assert @wiki_page.respond_to?(:is_game_master_only?)
      [true, false].each do |v|
        @wiki_page.is_game_master_only = v
        assert_equal @wiki_page.is_game_master_only, @wiki_page.is_game_master_only?
      end
    end
  end
end