module MageHand
  class OPUser < Base
    # @!attribute username
    # @return [String] the users name on Obsidian Portal
    attr_simple :username

    # @!attribute profile_url
    # @todo make this an actual URL object
    # @return [String] the url for the user's Obsidian Portal profile
    attr_simple :profile_url

    # @!attribute avatar_image_url
    # @todo make this an actual URL object
    # @return [String] the url for the user'savatar image
    attr_simple :avatar_image_url
    inflate_if_nil :avatar_image_url

    # @!attribute created_at
    # @todo make this an actual time object
    # @return [String] the date and time this user joined Obsidian Portal
    attr_simple :created_at
    inflate_if_nil :created_at

    # @!attribute updated_at
    # @todo make this an actual time object
    # @return [String] the date and time of this user's last profile update
    attr_simple :updated_at
    inflate_if_nil :updated_at

    # @!attribute last_seen_at
    # @todo make this an actual time object
    # @return [String] the date and time this use was last seen on Obsidian Portal
    attr_simple :last_seen_at
    inflate_if_nil :last_seen_at

    # @1attribute utc_offset
    # @return [String] formatted string representing the users timezone
    attr_simple :utc_offset
    inflate_if_nil :utc_offset

    # @!attribute locale
    # @return  ISO 639-1 language code for the user's preferred language.
    attr_simple :locale
    inflate_if_nil :locale

    # @!attribute is_ascendant
    # @return [Boolean] true if the user is and Ascendant (paid) member of Obsidian Portal
    attr_simple :is_ascendant
    inflate_if_nil :is_ascendant
    alias :is_ascendant? :is_ascendant

    # @!attribute campaign
    # @return [Array<Campaign>] list of campaigns this user participates in
    attr_array :campaigns, :class_name => 'Campaign'
    inflate_if_nil :campaigns
    
    private

    def individual_url
      "/v1/users/#{self.id}.json"
    end
  end
end