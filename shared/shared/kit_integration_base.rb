module KitIntegrationBase
  ############################################################
  #
  # Kit specific interface
  #
  ############################################################

  ############################################################
  #
  # Subscribers
  #
  def view_single_subscriber id
    res=call_api(:get,"subscribers/#{id}")
    puts "LEELEE: res=#{res.inspect}"
    return nil if res["error"].present?
    res["subscriber"]
  end
  def list_tags_for_subscriber id
    res=call_api(:get,"/subscribers/#{id}/tags")
    return nil if res["error"].present?
    res["tags"]
  end


  ############################################################
  #
  # Private
  #
  ############################################################
  private

  ##############################
  # Auto-version selector interface to Kit
  ##############################
  def call_api method,api,data={}
    if self.v4_api_key.present? || self.v4_bearer_token.present?
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
      return {"error" => "No v4 API key specified"} unless self.v4_api_key? || self.v4_bearer_token
    else
      return {"error" => "No v3 API key/secret specified"} unless self.v3_api_key? || self.v3_api_secret?
    end

    #
    # Add v3 data value for API Key/Secret to the data packet
    #
    if version == :v3
      if self.v3_api_secret?
        logger.info "LEELEE: v3 secret=#{self.v3_api_secret}"
        data["api_secret"]=self.v3_api_secret
      else
        logger.info "LEELEE: v3 key=#{self.v3_api_key}"
        data["api_key"]=self.v3_api_key
      end
    end

    #
    # Setup the URI
    #
    uri = URI("https://api.convertkit.com/#{version}/#{api}")
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
        if self.v4_bearer_token.present?
          logger.info "LEELEE: Bearer token=#{self.v4_bearer_token}"
          req['Authorization']="Bearer #{self.v4_bearer_token}"
        else
          logger.info "LEELEE: Bearer API Key=#{self.v4_api_key}"
          req['X-Kit-Api-Key']=self.v4_api_key
        end
      end

      # Send the request
      http.request(req)
    end

    #
    # Parse the response
    #
    JSON.parse(resp.body)
  end

end


############################################################
############################################################
############################################################
############################################################
############################################################
############################################################
############################################################
############################################################
############################################################
############################################################
############################################################
=begin
class Integrations::Convertkit < Integration
  settings_accessor :api_key,:api_secret


  ############################################################
  #
  # Subscribers
  #

  def update_fields_subscriber id, fields
    data = {}
    data["first_name"] = fields["first_name"] if fields["first_name"].present?
    data["email_address"] = fields["email_address"] if fields["email_address"].present?
    fields.delete("email_address")
    fields.delete("first_name")
    data["fields"]=fields if fields.size > 0
    res = call_api_put_v3("/v3/subscribers/#{id}",data)
    return nil if res["error"].present?
    res['subscriber']
  end

  def add_tags_subscriber email_address, tag_array
    tag_array.each do |tag|
      req = {}
      req["email"]=email_address
      res=call_api_post_v3 "/v3/tags/#{tag}/subscribe",req
    end
    nil
  end
  def delete_tags_subscriber id, tag_array
    tag_array.each do |tag|
      res=call_api_delete_v3 "/v3/subscribers/#{id}/tags/#{tag}"
    end
    nil
  end

end
=end
