class BaseRenderer
  def initialize
  end

  def get_prioritized_style key, *obj_list
    obj_list.each do |obj|
      val = obj.styles[key.to_s]
      return val if val.present?
    end
    nil
  end
  def get_prioritized_style_with_alt_inherit_value key, inherit_value, *obj_list
    obj_list.each do |obj|
      val = obj.styles[key.to_s]
      return val if val.present? && val != inherit_value
    end
    inherit_value
  end

  def hashToStyleString hash
    hash.map{|k,v|"#{k}:#{v}"}.join(';')
  end

  private

  def shared_h1_h6_renderer hash, h1_font_size
    # LEELEE: also fill in "color:" CSS attributes for each of the six
    hash["h1"]=hashToStyleString({"font-size"=>"#{h1_font_size.to_i}px"})
    hash["h2"]=hashToStyleString({"font-size"=>"#{(h1_font_size.to_i*3/4).to_i.to_s}px"})
    hash["h3"]=hashToStyleString({"font-size"=>"#{(h1_font_size.to_i*2/3).to_i.to_s}px"})
    hash["h4"]=hashToStyleString({"font-size"=>"#{(h1_font_size.to_i*1/2).to_i.to_s}px"})
    hash["h5"]=hashToStyleString({"font-size"=>"#{(h1_font_size.to_i*1/3).to_i.to_s}px"})
    hash["h6"]=hashToStyleString({"font-size"=>"#{(h1_font_size.to_i*1/4).to_i.to_s}px"})
  end
end
