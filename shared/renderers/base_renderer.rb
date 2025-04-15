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
end
