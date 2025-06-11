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
    if page.styles["body_background"].blank?
      return SiteRenderer.new(site).page_render_body
    end
    retHash = {}
    if page.styles["body_background"] == "color"
      retHash["background-color"]=page.styles['body_background_color']
    elsif page.styles["body_background"] == "image"
      retHash["background-image"]="url(#{page.body_background_image.url})" if page.body_background_image.present?
      retHash["background-position"]=page.styles['body_background_position'].gsub(/_/,' ')
      retHash["background-repeat"]=page.styles['body_background_tile'].gsub(/_/,'-')
      retHash["background-attachment"]=page.styles['body_background_attachment']
      retHash["background-size"]=page.styles['body_background_size']
      retHash["background-color"]=page.styles['body_background_color']
    end
    hashToStyleString retHash
  end
  def render_tcc_outer_body
    retHash = {}
    hashToStyleString retHash
  end

  def render_tcc_inner_body
    if page.styles["body_background"].blank?
      return SiteRenderer.new(site).page_render_tcc_inner_body
    end
    retHash = {}
    if page.styles["background"] == "color"
      retHash["background-color"]=page.styles['background_color']
    elsif page.styles["background"] == "image"
      retHash["background-image"]="url(#{page.background_image.url})" if page.background_image.present?
      retHash["background-position"]=page.styles['background_position'].gsub(/_/,' ')
      retHash["background-repeat"]=page.styles['background_tile'].gsub(/_/,'-')
      retHash["background-attachment"]=page.styles['background_attachment']
      retHash["background-size"]=page.styles['background_size']
      retHash["background-color"]=page.styles['background_color']
    end
    hashToStyleString retHash
  end

end

