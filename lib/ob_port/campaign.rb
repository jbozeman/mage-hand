module MageHand
  # Describes a campaign on Obsidian Portal. Includes finders to get the campaign by id or slub
  # as well as instance methods for the various attributes.
  # @note Several attributes may be nil if the object was instantiated from a min-object. Accessing
  #   these attributes while nil will cause the full set of data to be fetched from OP and the current
  #   instance inflated with that data.
  # @note The Obsidian Portal API does not allow creating or updating of campaigns, so any changes
  #   to the campaign cannot be written back to Obsidian Portal
  # @todo created_at and updated_at should return strings
  # @author Steven Hammond (@shammond42)
  class Campaign < Base
    # @!attribute name
    #   @return [String] the name of this campaign.
    attr_simple :name, :campaign_url

    # @!attribute role
    #   @return [String] the current users role in the campaign, either 'player' or 'game_master'.
    #   @see #humanized_role
    attr_simple :role, :visibility
    
    # @!attribute slug
    #   @note will attempt to retrieve the full object from Obsidian Portal if this is nil.
    #   @return [String] the dashed slug that identifies this campaign on Obsidian Portal.
    attr_simple :slug
    inflate_if_nil :slug

    # @!attribute game_master
    #   @note will attempt to retrieve the full object from Obsidian Portal if this is nil.
    #   @return [OPUser] the game master for this campaign.
    attr_instance :game_master, :class_name => 'OPUser'
    inflate_if_nil :game_master
    
    # Visiblity: Private/Friends

    # @!attribute banner_image_url
    #   @note will attempt to retrieve the full object from Obsidian Portal if this is nil.
    #   @note if the campaign is private this attribute is only visible to GM, players, and friends
    #   @return [String] url to retrieve the banner image
    attr_simple :banner_image_url
    inflate_if_nil :banner_image_url
    
    # @!attribute play_status
    #   @note will attempt to retrieve the full object from Obsidian Portal if this is nil.
    #   @note if the campaign is private this attribute is only visible to GM, players, and friends
    #   @return [String] current campaign status. One of "in_planning", "current_playing", "on_hiatus",
    #     "completed"
    attr_simple :play_status
    inflate_if_nil :play_status

    # @!attribute looking_for_players
    #   @note will attempt to retrieve the full object from Obsidian Portal if this is nil.
    #   @note if the campaign is private this attribute is only visible to GM, players, and friends
    #   @see #looking_for_players?
    #   @return [Boolean] is this campaign looking for players
    attr_simple :looking_for_players
    inflate_if_nil :looking_for_players

    # @!attribute created_at
    #   @note will attempt to retrieve the full object from Obsidian Portal if this is nil.
    #   @note if the campaign is private this attribute is only visible to GM, players, and friends
    #   @return [String] date the campaign was created
    attr_simple :created_at
    inflate_if_nil :created_at

    # @!attribute updated_at
    #   @note will attempt to retrieve the full object from Obsidian Portal if this is nil.
    #   @note if the campaign is private this attribute is only visible to GM, players, and friends
    #   @return [String] date the campaign was updated
    attr_simple :updated_at
    inflate_if_nil :updated_at

    # @!attribute location
    #   @note will attempt to retrieve the full object from Obsidian Portal if this is nil.
    #   @note if the campaign is private this attribute is only visible to GM, players, and friends
    #   @return [Location] the latitude and longitude of the campagin
    attr_instance :location, :class_name => 'Location'
    inflate_if_nil :location
    
    # @!attribute players
    #   @note will attempt to retrieve the full object from Obsidian Portal if this is nil.
    #   @note if the campaign is private this attribute is only visible to GM, players, and friends
    #   @return [Array<OPUser>] array of players in this campaign
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