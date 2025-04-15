class SiteRenderer < BaseRenderer
  attr_reader :site

  def initialize(site)
    @site = site
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
    if site.styles["body_background"] == "color"
      retHash["background-color"]=site.styles['body_background_color']
    elsif site.styles["body_background"] == "image"
      retHash["background-image"]="url(#{site.body_background_image.url})"
      retHash["background-position"]=site.styles['body_background_position'].gsub(/_/,' ')
      retHash["background-repeat"]=site.styles['body_background_tile'].gsub(/_/,'-')
      retHash["background-attachment"]=site.styles['body_background_attachment']
      retHash["background-size"]=site.styles['body_background_size']
      retHash["background-color"]=site.styles['body_background_color']
    end
    hashToStyleString retHash
  end
  def render_tcc_outer_body
    retHash = {}
    width = site.styles['page_widths'] || StylesConfig[:defaults][:site_styles][:page_widths]
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
    retHash['font-family'] = site.styles['font_family'] || StylesConfig[:defaults][:site_styles][:font_family]
    retHash['font-size'] = site.styles['font_size'] || StylesConfig[:defaults][:site_styles][:font_size]
    retHash['line-height'] = site.styles['line_height'] || StylesConfig[:defaults][:site_styles][:line_height]
    if site.styles["background"] == "color"
      retHash["background-color"]=site.styles['background_color']
    elsif site.styles["background"] == "image"
      retHash["background-image"]="url(#{site.background_image.url})"
      retHash["background-position"]=site.styles['background_position'].gsub(/_/,' ')
      retHash["background-repeat"]=site.styles['background_tile'].gsub(/_/,'-')
      retHash["background-attachment"]=site.styles['background_attachment']
      retHash["background-size"]=site.styles['background_size']
      retHash["background-color"]=site.styles['background_color']
    end
    hashToStyleString retHash
  end

  def render_caption
    retHash = {}
    retHash['font-size'] = site.styles['caption_font_size'] || StylesConfig[:defaults][:site_styles][:caption_font_size]
    hashToStyleString retHash
  end

  def render_h1_h6 hash
    h1_font_size = site.styles['h1_font_size'] || StylesConfig[:defaults][:site_styles][:h1_font_size]
    # LEELEE: also fill in "color:" CSS attributes for each of the six
    hash["h1"]=hashToStyleString({"font-size"=>h1_font_size})
    hash["h2"]=hashToStyleString({"font-size"=>(h1_font_size.to_i*3/4).to_i.to_s})
    hash["h3"]=hashToStyleString({"font-size"=>(h1_font_size.to_i*2/3).to_i.to_s})
    hash["h4"]=hashToStyleString({"font-size"=>(h1_font_size.to_i*1/2).to_i.to_s})
    hash["h5"]=hashToStyleString({"font-size"=>(h1_font_size.to_i*1/3).to_i.to_s})
    hash["h6"]=hashToStyleString({"font-size"=>(h1_font_size.to_i*1/4).to_i.to_s})
  end



end

