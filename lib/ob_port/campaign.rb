module MageHand
  class Campaign < Base
    # public mini-object methods

    # @return [String] the name of this campaign.
    attr_simple :name, :campaign_url

    # @return [String] the current users role in the campaign, either 'player' or 'game_master'.
    # @see #humanized_role
    attr_simple :role, :visibility
    
    # @return [String] the dashed slug that identifies this campaign on Obsidian Portal.
    attr_simple :slug

    # @return [OPUser] the game master for this campaign. Will try to inflate the object if
    # currently nil
    attr_instance :game_master, :class_name => 'OPUser'
    inflate_if_nil :game_master, :slug
    
    # Private/Friends
    attr_simple :banner_image_url, :play_status, :looking_for_players, :created_at, :updated_at
    inflate_if_nil :banner_image_url, :play_status, :looking_for_players, :created_at, :updated_at
    
    # Player/GM Only
    attr_instance :location, :class_name => 'Location'
    inflate_if_nil :location
    
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

    # The current user's role in this campaign as a human readable string.
    # @return [String] one of 'Player' or 'Game Master'
    def humanized_role
      role.titleize
    end
    
    # Get all of the wiki pages for this campaign. Includes adventure log posts
    # which are just a type of wiki page.
    # @return [Array] array of wiki pages.
    def all_wiki_pages
      @all_wiki_pages ||= MageHand::WikiPage.load_wiki_pages(self)
    end

    # Get the wiki pages for this campaign which are not adventure log posts.
    # @return [Array] array of wiki pages.
    def wiki_pages
      @wiki_pages ||= all_wiki_pages.select{|page| !page.is_post?}
    end

    # Get all of the adventure log posts for this campaign. These are not currently
    # sorted by post_time, oldest first.
    # @return [Array] sorted array of adventure log posts.
    def posts
      @posts ||= all_wiki_pages.select{|page| page.is_post?}.sort_by(&:post_time)
    end
     
     protected

     def individual_url
       "/v1/campaigns/#{self.id}.json"
     end
  end
end