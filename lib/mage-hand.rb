require 'OAuth'
require 'json'
require 'active_support/core_ext/string'
require 'ob_port/client'
require 'ob_port/base'
require 'ob_port/user'
require 'ob_port/campaign'
require 'ob_port/wiki_page'
require 'ob_port/errors'

require 'mage-hand-user'

module MageHand
  def self.set_app_keys(app_key, app_secret)
    Client.set_app_keys(app_key, app_secret)
  end
  
  def self.get_client(session_request_token=nil, session_access_token_key=nil, session_access_token_secret=nil,
      callback=nil, params=nil)
    Client.get_client(session_request_token, session_access_token_key, session_access_token_secret,
          callback, params)
  end
end

module MageHandController
  include MageHand
  protected
  
  def obsidian_portal_login_required
    obsidian_portal
    store_tokens
    return true if logged_in?

    redirect_to @mage_client.request_token.authorize_url
    false
  end
  
  def logged_in_op?
    !!@obsidian_portal && @obsidian_portal.logged_in?
  end
  
  def obsidian_portal
    @obsidian_portal ||= Client.get_client(session[:request_token], session[:access_token_key], 
      session[:access_token_secret], request.url, params)
  end
  
  def store_tokens
    current_user.save_op_tokens(@mage_client.access_token_key, @mage_client.access_token_secret) if current_user
    session[:request_token] = @mage_client.request_token
    session[:access_token_key] = @mage_client.access_token_key
    session[:access_token_secret] = @mage_client.access_token_secret
  end
end
