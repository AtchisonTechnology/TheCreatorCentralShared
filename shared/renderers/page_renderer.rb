class PageRenderer < BaseRenderer
  attr_reader :page
  attr_reader :site

  def initialize(page)
    @page = page
    @site = page.site
    super()
  end

  def render
    ret = {}
    ret["body"] = render_body
    ret["tcc_outer_body"] = render_tcc_outer_body
    ret["tcc_inner_body"] = render_tcc_inner_body
    ret
  end

  private

  def render_body
    retHash = {}
    puts "LEELEE: page.body_background_image: #{page.body_background_image.inspect}"
    if get_prioritized_style("body_background",page,site) == "color"
      retHash["background-color"]=get_prioritized_style_with_alt_inherit_value("body_background_color","#000000",page,site)
    elsif get_prioritized_style("body_background",page,site) == "image"
      retHash["background-image"]="url(#{page.body_background_image&.url})"
      retHash["background-position"]=get_prioritized_style('body_background_position',page,site).gsub(/_/,' ')
      retHash["background-repeat"]=get_prioritized_style('body_background_tile',page,site).gsub(/_/,'-')
      retHash["background-attachment"]=get_prioritized_style('body_background_attachment',page,site)
      retHash["background-size"]=get_prioritized_style('body_background_size',page,site)
      retHash["background-color"]=get_prioritized_style_with_alt_inherit_value("background_color","#000000",page,site)
    end
    puts "LEELEE: retHash: #{retHash.inspect}"
    hashToStyleString retHash
  end
  def render_tcc_outer_body
    retHash = {}
    hashToStyleString retHash
  end

  def render_tcc_inner_body
    retHash = {}
    if get_prioritized_style("background",page,site) == "color"
      retHash["background-color"]=get_prioritized_style_with_alt_inherit_value("background_color","#000000",page,site)
    elsif get_prioritized_style("background",page,site) == "image"
      retHash["background-image"]="url(#{page.background_image&.url})"
      retHash["background-position"]=get_prioritized_style('background_position',page,site).gsub(/_/,' ')
      retHash["background-repeat"]=get_prioritized_style('background_tile',page,site).gsub(/_/,'-')
      retHash["background-attachment"]=get_prioritized_style('background_attachment',page,site)
      retHash["background-size"]=get_prioritized_style('background_size',page,site)
      retHash["background-color"]=get_prioritized_style_with_alt_inherit_value("background_color","#000000",page,site)
    end
    hashToStyleString retHash
  end

end

