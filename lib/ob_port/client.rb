module MageHand
  class Client
    attr_accessor :request_token, :access_token_key, :access_token_secret
    
    def self.set_app_keys(key, secret)
      @@key = key
      @@secret = secret
    end
    
    def self.get_client(session_request_token=nil, session_access_token_key=nil, session_access_token_secret=nil,
        callback=nil, params=nil)
        Client.new(session_request_token, session_access_token_key, session_access_token_secret,
          callback, params)
    end
    
    def initialize(session_request_token=nil, session_access_token_key=nil, session_access_token_secret=nil,
        callback=nil, params=nil)
      @request_token = session_request_token
      @access_token_key = session_access_token_key
      @access_token_secret = session_access_token_secret
        
      if !logged_in? && params && params[:oauth_verifier]
        temp_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
        @access_token_key = temp_token.token
        @access_token_secret = temp_token.secret          
      elsif !logged_in?
        @request_token = consumer.get_request_token(:oauth_callback => callback)
      end
    end
    
    def logged_in?
      !!access_token_secret && !!access_token_key
    end
    
    def authorized?
      logged_in? && !!current_user
    end

    def consumer
      raise(OAuthConfigurationError, "Need to set application key and secret before initializing a consumer.") unless
        @@key && @@secret
      @consumer ||= OAuth::Consumer.new( @@key, @@secret, {
        :site => 'http://api.obsidianportal.com',
        :request_token_url => 'https://www.obsidianportal.com/oauth/request_token',
        :authorize_url => 'https://www.obsidianportal.com/oauth/authorize',
        :access_token_url => 'https://www.obsidianportal.com/oauth/access_token'})
    end
    
    def access_token
      return nil unless logged_in?
      @access_token ||= OAuth::AccessToken.new(consumer, access_token_key, access_token_secret)          
    end
    
    def current_user
      return @current_user if @current_user

      response = access_token.get('/v1/users/me.json')
      return nil if response.code == '401'
      @current_user = OPUser.new(self, JSON.parse(response.body))
    end
    alias :me :current_user
    
    def campaign(id)
      MageHand::Campaign.new(self, JSON.parse(access_token.get("/v1/campaigns/#{id}.json").body))
    end
    
    def create_wiki_page(options)
      MageHand::WikiPage.new(self, options)
    end
    
    protected
    
    def self.reset_client
      @@key = nil
      @@secret = nil
    end
  end
end