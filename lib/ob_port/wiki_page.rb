module MageHand
  class WikiPage < Base
    ROLES = {'game_master' => 'Game Master', 'player' => 'Player'}
    
    # public methods
    attr_simple :slug, :name, :wiki_page_url, :campaign, :created_at, :updated_at
    
    # Private/Friends
    attr_simple :type, :is_game_master_only, :body, :body_html, :tags
    inflate_if_nil :body, :body_html
    
    # TODO Move these to the posts subclass when we have it.
    attr_simple :post_title, :post_tagline, :post_time
    
    # GM Only fields
    attr_simple :game_master_info, :game_master_info_markup
    inflate_if_nil :game_master_info, :game_master_info_markup
    
    def self.load_wiki_pages(campaign_id)
      wiki_hashes = JSON.parse(
        MageHand::get_client.access_token.get(collection_url(campaign_id)).body)
      wiki_hashes.map {|hash| WikiPage.new(hash)}
    end
    
    def campaign=(campaign_hash)
      @campaign ||= Campaign.new(campaign_hash)
    end
    
    def is_post?
      type == 'Post'
    end
    
    def save!
      if id # save existing wiki pae
        
      else # create new wiki page
        self.update_attributes!(
          JSON.parse(
            MageHand::get_client.access_token.post(self.class.collection_url(self.campaign.id),
            {'wiki_page' => self}.to_json)
          ).body
        )
      end
    end
    
    private
    
    def self.collection_url(campaign_id)
      "/v1/campaigns/#{campaign_id}/wikis.json"
    end
    
    def individual_url
      "/v1/campaigns/#{self.campaign.id}/wikis/#{self.id}.json?"
    end
  end
end