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
    ret
  end

  private

  def render_body
    retHash = {}
    retHash["background-color"] = "green"; # LEELEE
    # LEELEE
    hashToStyleString retHash
  end
  def render_tcc_outer_body
    retHash = {}
    retHash["background-color"] = "pink" # LEELEE
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
    retHash['background-color'] = 'red';
    retHash['font-family'] = site.styles['font_family'] || StylesConfig[:defaults][:site_styles][:font_family]
    retHash['font-size'] = site.styles['font_size'] || StylesConfig[:defaults][:site_styles][:font_size]
    # retHash['line-height'] = xxx;
    # LEELEE
    hashToStyleString retHash
  end

  def render_caption
    retHash = {}
    # LEELEE
    hashToStyleString retHash
  end
end

