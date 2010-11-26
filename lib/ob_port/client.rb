module MageHand
  LOGIN_URL = 'http://www.obsidianportal.com/'
  API_URL = 'http://api.obsidianportal.com/v1/users/me.json'
  
  class Client
    cattr_accessor :key, :secret
    attr_accessor :request_token, :access_token_key, :access_token_secret
    
    def self.configure(key, secret)
      self.key = key
      self.secret = secret
    end
        
    def initialize(session_request_token=nil, session_access_token_key=nil, session_access_token_secret=nil,
        callback=nil, params=nil)
      @request_token = session_request_token
      @access_token_key = session_access_token_key
      @access_token_secret = session_access_token_secret
        
      if !logged_in? && params[:oauth_verifier]
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
    
    def consumer
      @consumer ||= OAuth::Consumer.new( Client.key,Client.secret, {
        :site => 'http://api.obsidianportal.com',
        :request_token_url => 'https://www.obsidianportal.com/oauth/request_token',
        :authorize_url => 'https://www.obsidianportal.com/oauth/authorize',
        :access_token_url => 'https://www.obsidianportal.com/oauth/access_token'})
    end
    
    def access_token
      return nil unless logged_in?
      @access_token ||= OAuth::AccessToken.new(consumer, access_token_key, access_token_secret)          
    end
  end
end