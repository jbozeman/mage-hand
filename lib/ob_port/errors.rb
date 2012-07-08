module MageHand
  # raised when calls to mage hand are made without proper initialization.
  class MageHandNotInitialized < StandardError; end

  # raised as a result of an oauth configuration error.
  class OAuthConfigurationError < StandardError; end

  # raised when an attempt is made to create a new wiki page with the same name
  # as one that already exists.
  class WikiPageExists < StandardError; end

  # raised when Obsidian Portal reports some error saving a wiki page
  class WikiPageError < StandardError; end
end