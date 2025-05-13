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
    hashToStyleString retHash
  end

  def render_tcc_inner_body
    retHash = {}
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

end

