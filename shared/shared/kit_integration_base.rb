module KitIntegrationBase
  KitStoreIntegrationDetailPageUrl = "https://app.kit.com/apps/1202"
  ########################################################################################################################
  #
  #
  # Kit specific interface
  #
  #
  ########################################################################################################################

  ############################################################
  #
  # Subscribers
  #
  def view_single_subscriber id
    res=call_api(:get,"subscribers/#{id}")
    return nil if res["error"].present?
    res["subscriber"]
  end
  def list_tags_for_subscriber id
    res=call_api(:get,"/subscribers/#{id}/tags")
    return nil if res["error"].present?
    res["tags"]
  end

  def update_fields_subscriber id, fields
    data = {}
    data["first_name"] = fields["first_name"] if fields["first_name"].present?
    data["email_address"] = fields["email_address"] if fields["email_address"].present?
    fields.delete("email_address")
    fields.delete("first_name")
    data["fields"]=fields if fields.size > 0
    res = call_api :put,"subscribers/#{id}",data
    return nil if res["error"].present?
    res['subscriber']
  end

  def add_tags_subscriber id, tag_array
    tag_array.each do |tag|
      req = {}
      res=call_api :post, "tags/#{tag}/subscribers/#{id}",req
    end
    nil
  end
  def delete_tags_subscriber id, tag_array
    tag_array.each do |tag|
      res=call_api :delete, "tags/#{tag}/subscribers/#{id}"
    end
    nil
  end


  ############################################################
  #
  # Account
  #
  def account_name
    res=call_api(:get,'account')
    res["account"]&.[]("name") || "Not Available"
  end

  ############################################################
  #
  # Broadcasts
  #
  def create_broadcast subject, content, opts={}
    data = opts
    data[:subject] = subject
    data[:content] = content
    res = call_api(:post,"broadcasts", data)
    return nil if res["error"].present?
    res["broadcast"]
  end
  # # API doesn't work yet...
  # # def update_broadcast broadcast_id, subject=nil, content=nil, opts={}
  # #   data = opts
  # #   data[:subject] = subject unless subject.nil?
  # #   data[:content] = content unless content.nil?
  # #   call_api_put "/v3/broadcasts/#{broadcast_id}", data
  # # end
  # def list_broadcasts data={}
  #   res=call_api_get("/v3/broadcasts",data)
  #   return nil if res["error"].present?
  #   res["broadcasts"]
  # end
  # def retrieve_broadcast broadcast_id
  #   res = call_api_get("/v3/broadcasts/#{broadcast_id}")
  #   return nil if res["error"].present?
  #   res["broadcast"]
  # end
  # def get_stats broadcast_id
  #   res = call_api_get("/v3/broadcasts/#{broadcast_id}/stats")
  #   return nil if res["error"].present?
  #   res["broadcast"]
  # end


  ############################################################
  #
  # Forms
  #
  def list_forms
    res=call_api(:get,'forms')
    return [] if res["error"].present?
    res["forms"]
  end

  ############################################################
  #
  # Custom Fields
  #
  def list_fields
    res=call_api(:get,'custom_fields')
    return [] if res["error"].present?
    res["custom_fields"]
  end

  ############################################################
  #
  # Tags
  #
  def list_tags
    res=call_api(:get,'tags')
    return [] if res["error"].present?
    res["tags"]
  end

  ########################################################################################################################
  #
  #
  # Support Methods for Integration API Calls
  #
  #
  ########################################################################################################################

  #
  #
  # Get identity objects...
  #
  #
  def identity
    return nil if self.identity_id.blank?
    @identity ||= Identity.where(provider: "kit_oauth2").find(self.identity_id)
  end
  def identity= identity
    self.identity_id = identity.id
    @identity = nil
  end


  #
  #
  # Process bearer token lifespan
  #
  #
  def expire_v4_bearer_token
    # Force expire the current bearer token, forcing a refresh
    self.identity.token = nil
    self.identity.token_expires_at = 5.seconds.ago
    self.identity.save!
  end
  def refresh_v4_token
    logger.info "Kit[#{self.id}] v4 bearer token requires refreshing..."
    uri = URI("https://app.kit.com/oauth/token")
    resp = Net::HTTP.start(uri.hostname,uri.port,use_ssl: true) do |http|
      req = Net::HTTP::Post.new(uri)
      req.body= {
        "client_id": Rails.application.credentials.dig(:kit_oauth2, :client_id),
        "grant_type": "refresh_token",
        "refresh_token": self.identity.refresh_token,
      }.to_json
      req.content_type="application/json"
      http.request(req)
    end
    ret = JSON.parse(resp.body)
    raise "Refresh token error: #{ret['error_description']}" if ret["error"].present?
    self.identity.token = ret["access_token"]
    self.identity.token_expires_at = Time.now + ret["expires_in"].seconds
    self.identity.save!
  end


  ############################################################
  #
  # Private
  #
  ############################################################
  private

  def is_v4_available?
    self.v4_api_key.present? || self.identity.present?
  end
  def get_valid_v4_bearer_token
    # Development V4 API Key available? If so, use that...
    return self.v4_api_key if self.v4_api_key.present?

    # Return error if no identity is associated with this integration
    return nil if self.identity_id.blank?

    # Return current bearer token if it is available and not expired.
    return self.identity.token if self.identity.token_expires_at > 5.seconds.from_now and self.identity.token.present?

    # Otherwise, we need to refresh the token
    self.refresh_v4_token

    # Return the new bearer token
    return self.identity.token
  end

  ##############################
  # Auto-version selector interface to Kit
  ##############################
  def call_api method,api,data={}
    if is_v4_available?
      call_api_version(:v4,method,api,data)
    else
      call_api_version(:v3,method,api,data)
    end
  end

  ##############################
  # Primary interface to Kit
  ##############################
  def call_api_version version,method,api,data={}
    logger.info "Kit[#{id}]: call_api(:#{version},:#{method},#{api.inspect})"
    #
    # Verify we have the right credentials for given API version
    #
    if version == :v4
      return {"error" => "No v4 API key specified"} unless self.v4_api_key? || self.is_v4_available?
    else
      return {"error" => "No v3 API key/secret specified"} unless self.v3_api_key? || self.v3_api_secret?
    end

    #
    # Add v3 data value for API Key/Secret to the data packet
    #
    if version == :v3
      if self.v3_api_secret?
        data["api_secret"]=self.v3_api_secret
      else
        data["api_key"]=self.v3_api_key
      end
    end

    #
    # Setup the URI
    #
    uri = URI("https://api.kit.com/#{version}/#{api}")
    logger.info "Kit: URI: #{uri.inspect}"
    if [:get,:delete].include?(method)
      uri.query = URI.encode_www_form(data)
    end

    #
    # Setup & send the request
    #
    resp = Net::HTTP.start(uri.hostname,uri.port,use_ssl: true) do |http|
      req = "Net::HTTP::#{method.capitalize}".constantize.new(uri)
      if [:put,:post].include?(method)
        req.body=data.to_json
        req.content_type="application/json"
      end

      # Insert v4 credentials in the header
      if version==:v4
        if self.get_valid_v4_bearer_token.present?
          req['Authorization']="Bearer #{self.get_valid_v4_bearer_token}"
        else
          req['X-Kit-Api-Key']=self.v4_api_key
        end
      end

      # Send the request
      http.request(req)
    end

    #
    # Parse the response
    #
    return {} if resp.body.nil?
    JSON.parse(resp.body)
  end

end

