class BaseRenderer
  def initialize
  end

  def hashToStyleString hash
    hash.map{|k,v|"#{k}:#{v}"}.join(';')
  end
end
