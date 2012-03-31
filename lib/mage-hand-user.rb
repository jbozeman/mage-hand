module MageHandUser
  include MageHand
  
  def save_op_tokens(access_token_key, access_token_secret)
    self.access_token_key = access_token_key
    self.access_token_secret = access_token_secret
    
    save!
  end

  def obsidian_portal
    @obsidian_portal ||= MageHand.get_client(nil, access_token_key, 
      access_token_secret)
  end
end
