class UrlCreator
  def self.full_host host_hash, opts={}
    host_hash = {} unless host_hash
    protocol = opts[:protocol] || host_hash[:protocol] || host_hash["protocol"] || "https"
    subdomain = opts[:subdomain] || host_hash[:subdomain] || host_hash["subdomain"]
    host = opts[:host] || opts[:hostname] || host_hash[:host] || host_hash[:hostname] || host_hash["host"] || host_hash["hostname"] || "thecreatorcentral.site"
    port = opts[:port] || host_hash[:port] || host_hash["port"]
    uri = opts[:uri] || host_hash[:uri] || host_hash["uri"]
    custom_domain = opts[:custom_domain]

    url = protocol.to_s+"://"
    if custom_domain.present?
      url += custom_domain.to_s
    else
      url += subdomain.to_s+"." if subdomain
      url += host.to_s
    end
    url += ":"+port.to_s if port
    url += uri.to_s if uri
    url
  end

end
