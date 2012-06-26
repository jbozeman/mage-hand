module MageHand
  class Campaign < Base
    # public mini-object methods
    attr_simple :name, :campaign_url, :role, :visibility
    
    attr_simple :slug
    attr_instance :game_master, :class_name => 'OPUser'
    inflate_if_nil :game_master, :slug
    
    # Private/Friends
    attr_simple :banner_image_url, :play_status, :looking_for_players, :created_at, :updated_at
    inflate_if_nil :banner_image_url, :play_status, :looking_for_players, :created_at, :updated_at
    
    # Player/GM Only
    attr_simple :lat, :lng
    inflate_if_nil :lat, :lng
    
    attr_array :players, :class_name => 'OPUser'
    inflate_if_nil :players

    # Queries Obsidian Portal for a campaign based on its slug.
    # @param [String] slug the dasherized campaign slug, like 'this-cool-campaign'
    # @return [Campaign] the full campaign object. 
    def self.find_by_slug(slug)
      hash = JSON.parse(client.access_token.get("/v1/campaigns/#{slug}.json?use_slug=true").body)
      Campaign.new(hash)
    end

    # Queries Obsidian Portal for a campaign based on its id.
    # @param [String] id the hash id for the campaign, like '453d0788f20111df8ad4d49a20038434'
    # @return [Campaign] the full campaign object.
    def self.find(id)
      hash = JSON.parse(client.access_token.get("/v1/campaigns/#{id}.json").body)
      Campaign.new(hash)
    end
    
    # Is this campaign looking for players
    # @return [Boolean] true if the campaign is looing for players, false otherwise
    def looking_for_players?
      looking_for_players
    end
    
    # @deprecated Use {#humanized_role} instead.
    def role_as_title_string
      humanized_role
    end

    # The current user's role in this campaign
    # @return [String] one of 'Player' or 'Game Master'
    def humanized_role
      role.titleize
    end
    
    # Get all of the wiki pages for this campaign. Includes adventure log posts
    # which are just a type of wiki page.
    # @return [Array] array of wiki pages.
    def wiki_pages
      @wiki_pages ||= MageHand::WikiPage.load_wiki_pages(self)
    end
    
    # Get all of the adventure log posts for this campaign. These are not currently
    # sorted by post_time, oldest first.
    # @return [Array] sorted array of adventure log posts.
    def posts
      @posts ||= wiki_pages.select{|page| page.is_post?}.sort_by(&:post_time)
    end
     
     protected

     def individual_url
       "/v1/campaigns/#{self.id}.json"
     end
  end
end