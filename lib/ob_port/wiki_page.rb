module MageHand
  class WikiPage < Base
    ROLES = {'game_master' => 'Game Master', 'player' => 'Player'}
    
    # public methods
    attr_simple :slug, :name, :wiki_page_url, :created_at, :updated_at
    
    # Private/Friends
    attr_simple :type, :is_game_master_only, :body, :body_html, :tags
    inflate_if_nil :body, :body_html
    
    # TODO Move these to the posts subclass when we have it.
    attr_simple :post_title, :post_tagline, :post_time
    
    # GM Only fields
    attr_simple :game_master_info, :game_master_info_markup
    inflate_if_nil :game_master_info, :game_master_info_markup
    
    attr_instance :campaign
    inflate_if_nil :campaign
    
    def self.load_wiki_pages(campaign)
      wiki_hashes = JSON.parse(campaign.client.access_token.get(collection_url(campaign.id)).body)
      wiki_hashes.map {|hash| WikiPage.new(campaign.client, hash)}
    end
    
    def campaign=(campaign_hash)
      @campaign = Campaign.new(client, campaign_hash)
    end
    
    def is_post?
      type == 'Post'
    end
    
    def to_hash
      attribute_hash = {}
      simple_attributes.each do |att|
        attribute_hash[att] = self.send(att) unless self.send(att).nil?
      end
      
      attribute_hash
    end
    
    def to_json
      to_hash.to_json
    end
    
    def save!
      if id # save existing wiki pae
        
      else # create new wiki page
        json_body = {'wiki_page' => self.to_hash}.to_json
        @response = client.access_token.post(self.class.collection_url(self.campaign.id),
          json_body,  {'content-type' => 'application/x-www-form-urlencoded'})
  puts "#{@response.code}: #{@response.message}"
  puts @response.body
        if @response.code == 200
          self.update_attributes!(JSON.parse(@response.body))
        else
          raise WikiPageExists if @response.body =~ /Name has already been taken/
        end
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