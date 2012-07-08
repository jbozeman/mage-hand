module MageHand
  # @todo model slug behavior correctly. It should change based on name. Need to test to see if we
  #    can save with a different slug and name. If not it should be read only. Changes to name should
  #    also change the slug (on save?)
  # @todo move to_hash and to_json into base.
  class WikiPage < Base
    # public methods

    # @!attribute slug
    #   @return [String] the slug for referencing htis page in a url
    attr_simple :slug

    # @!attribute name
    #   @return [String] the name (title) for this page
    attr_simple :name

    # @!attribute wiki_page_url
    #   @return [String] the URL for this page
    attr_simple :wiki_page_url

    # @!attribute created_at
    #  @todo return a date instead of a string
    #  @return [String] the date this page was created
    attr_simple :created_at

    # @!attribute updated_at
    #  @todo return a date instead of a string
    #  @return [String] the date this page was last updated
    attr_simple :updated_at
    
    # Private/Friends

    # @!attribute type
    #   @note if the campaign is private this attribute is only visible to GM, players, and friends
    #   @return [String] 'Post' or 'WikiPage' depending on the type of page this is
    attr_simple :type

    # @!attribute is_game_master_only
    #   @note if the campaign is private this attribute is only visible to GM, players, and friends
    #   @see #is_game_master_only?
    #   @return [Boolean] true if this page can only be seen by the game master
    attr_simple :is_game_master_only
    alias :is_game_master_only? :is_game_master_only

    # @!attribute body
    #   @note will attempt to retrieve the full object from Obsidian Portal if this is nil.
    #   @note if the campaign is private this attribute is only visible to GM, players, and friends
    #   @return [String] The textile markup for this page
    attr_simple :body
    inflate_if_nil :body

    # @!attribute body
    #   @note will attempt to retrieve the full object from Obsidian Portal if this is nil.
    #   @note if the campaign is private this attribute is only visible to GM, players, and friends
    #   @todo This should not be writeable
    #   @return [String] The html markup for this page
    attr_simple :body_html
    inflate_if_nil  :body_html

    # @!attribute tags
    #   @note if the campaign is private this attribute is only visible to GM, players, and friends
    #   @return [Array<String>] list of tags assigned to this page
    attr_simple :tags
    
    # @!attribute post_title
    #   @note if the campaign is private this attribute is only visible to GM, players, and friends
    #   @note this will be nil unless type = 'Post'
    #   @see #type
    #   @return [String] The title of this post
    attr_simple :post_title

    # @!attribute post_tagline
    #   @note if the campaign is private this attribute is only visible to GM, players, and friends
    #   @note this will be nil unless type = 'Post'
    #   @see #type
    #   @return [String] The tag line of this post
    attr_simple :post_tagline

    # @!attribute post_time
    #   @note if the campaign is private this attribute is only visible to GM, players, and friends
    #   @note this will be nil unless type = 'Post'
    #   @see #type
    #   @todo Return a date instead of a string
    #   @return [String] The timestamp for this post, typically the date/time of the events described
    #     in the post
    attr_simple :post_time
    
    # GM Only fields

    # @!attribute game_master_info
    #   @note this field will only be visible if the current user is the game master for this campaign.
    #   @note will attempt to retrieve the full object from Obsidian Portal if this is nil.
    #   @return [String] The textile markup of the game master section of this page
    attr_simple :game_master_info
    inflate_if_nil :game_master_info

    # @!attribute game_master_info_html
    #   @note this field will only be visible if the current user is the game master for this campaign.
    #   @note will attempt to retrieve the full object from Obsidian Portal if this is nil.
    #   @return [String] The html markup of the game master section of this page
    attr_simple :game_master_info_html
    inflate_if_nil :game_master_info_html

    # @!attribute campaign
    #   @note will attempt to retrieve the full object from Obsidian Portal if this is nil.
    #   @return [Campaign] the campaign this wiki page belongs to.
    attr_instance :campaign
    inflate_if_nil :campaign
    
    # Load all of the wiki pages for a campaign
    # @param [Campaign] campaign The campaign to retrieve the pages for.
    # @return [Array<WikiPage>] array of wiki pages. This will not be fully inflated.
    def self.load_wiki_pages(campaign)
      wiki_hashes = JSON.parse(campaign.client.access_token.get(collection_url(campaign.id)).body)
      wiki_hashes.map {|hash| WikiPage.new(campaign.client, hash)}
    end
    
    # Is this page a regular page or an adventure log post?
    # @return [Boolean] true if this page is an adventure log posting
    def is_post?
      type == 'Post'
    end
    
    # saves a new wiki page to Obsidian Portal, raising an exception in the event the
    # save fails.
    # @todo this should also update an existing wiki page
    # @return [WikiPage] self
    def save!
      if id # save existing wiki pae
        
      else # create new wiki page
        json_body = {'wiki_page' => self.to_hash}.to_json
        @response = client.access_token.post(self.class.collection_url(self.campaign.id),
          json_body,  {'content-type' => 'application/x-www-form-urlencoded'})

        if @response.code.to_i == 201
          self.update_attributes!(JSON.parse(@response.body))
        else
          raise WikiPageExists if @response.body =~ /Name has already been taken/
          raise WikiPageError(@response.body)
        end
      end

      self
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