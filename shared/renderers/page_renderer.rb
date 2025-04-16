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
    ret["caption"] = render_caption
    render_h1_h6 ret
    ret
  end

  private

  def render_body
    retHash = {}
    if get_prioritized_style("body_background",page,site) == "color"
      retHash["background-color"]=get_prioritized_style_with_alt_inherit_value("body_background_color","#000000",page,site)
    elsif get_prioritized_style("body_background",page,site) == "image"
      retHash["background-image"]="url(#{site.body_background_image.url})"
      retHash["background-position"]=get_prioritized_style('body_background_position',page,site).gsub(/_/,' ')
      retHash["background-repeat"]=get_prioritized_style('body_background_tile',page,site).gsub(/_/,'-')
      retHash["background-attachment"]=get_prioritized_style('body_background_attachment',page,site)
      retHash["background-size"]=get_prioritized_style('body_background_size',page,site)
      retHash["background-color"]=get_prioritized_style_with_alt_inherit_value("background_color","#000000",page,site)
    end
    hashToStyleString retHash
  end
  def render_tcc_outer_body
    retHash = {}
    width = get_prioritized_style('page_widths',page,site) || StylesConfig[:defaults][:site_styles][:page_widths]
    if width=='full' or width=='-'
      width = '100%'
    end
    retHash["max-width"] = width # LEELEE?
    retHash["min-width"] = width # LEELEE?
    retHash["width"] = width
    retHash["margin-left"] = "auto"
    retHash["margin-right"] = "auto"
    hashToStyleString retHash
  end

  def render_tcc_inner_body
    retHash = {}
    retHash['font-family'] = get_prioritized_style('font_family',page,site) || StylesConfig[:defaults][:site_styles][:font_family]
    retHash['font-size'] = get_prioritized_style('font_size',page,site) || StylesConfig[:defaults][:site_styles][:font_size]
    retHash['line-height'] = get_prioritized_style('line_height',page,site) || StylesConfig[:defaults][:site_styles][:line_height]
    if get_prioritized_style("background",page,site) == "color"
      retHash["background-color"]=get_prioritized_style_with_alt_inherit_value("background_color","#000000",page,site)
    elsif get_prioritized_style("background",page,site) == "image"
      retHash["background-image"]="url(#{site.background_image.url})"
      retHash["background-position"]=get_prioritized_style('background_position',page,site).gsub(/_/,' ')
      retHash["background-repeat"]=get_prioritized_style('background_tile',page,site).gsub(/_/,'-')
      retHash["background-attachment"]=get_prioritized_style('background_attachment',page,site)
      retHash["background-size"]=get_prioritized_style('background_size',page,site)
      retHash["background-color"]=get_prioritized_style_with_alt_inherit_value("background_color","#000000",page,site)
    end
    hashToStyleString retHash
  end

  def render_caption
    retHash = {}
    retHash['font-size'] = get_prioritized_style('caption_font_size',page,site) || StylesConfig[:defaults][:site_styles][:caption_font_size]
    hashToStyleString retHash
  end

  def render_h1_h6 hash
    h1_font_size = get_prioritized_style('h1_font_size',page,site) || StylesConfig[:defaults][:site_styles][:h1_font_size]
    # LEELEE: also fill in "color:" CSS attributes for each of the six
    hash["h1"]=hashToStyleString({"font-size"=>h1_font_size})
    hash["h2"]=hashToStyleString({"font-size"=>(h1_font_size.to_i*3/4).to_i.to_s})
    hash["h3"]=hashToStyleString({"font-size"=>(h1_font_size.to_i*2/3).to_i.to_s})
    hash["h4"]=hashToStyleString({"font-size"=>(h1_font_size.to_i*1/2).to_i.to_s})
    hash["h5"]=hashToStyleString({"font-size"=>(h1_font_size.to_i*1/3).to_i.to_s})
    hash["h6"]=hashToStyleString({"font-size"=>(h1_font_size.to_i*1/4).to_i.to_s})
  end



end

