module MageHand
  # Stores the location of a campaign as a lat, lng pair.
  # @author Steven Hammond (@shammond42)
  class Location < Base

    # @returns [String] the decimal latitude
    attr_accessor :lat

    # @returns [String] the decimal latitude
    attr_accessor :lng
  end
end