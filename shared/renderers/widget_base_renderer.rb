class WidgetBaseRenderer < BaseRenderer
  attr_reader :widget
  attr_reader :page
  attr_reader :site

  def initialize(widget)
    @widget = widget
    @page = widget.page
    @site = @page.site
    super()
  end

  def render
    ret = {}
    ret["tcc_widget_outer"] = tcc_widget_outer
    ret["tcc_widget"] = tcc_widget
    ret
  end

  private

  def tcc_widget_outer
    retHash = {}
    retHash["width"] = "100%"
    hashToStyleString retHash
  end
  def tcc_widget
    retHash = {}
    retHash["width"] = widget.styles["width"]
    retHash["color"] = widget.styles["text_color"]
    retHash["margin-top"] = widget.styles["margin_top"]
    retHash["margin-right"] = widget.styles["margin_right"]
    retHash["margin-bottom"] = widget.styles["margin_bottom"]
    retHash["margin-left"] = widget.styles["margin_left"]
    retHash["padding-top"] = widget.styles["padding_top"]
    retHash["padding-right"] = widget.styles["padding_right"]
    retHash["padding-bottom"] = widget.styles["padding_bottom"]
    retHash["padding-left"] = widget.styles["padding_left"]
    retHash["border"] = "#{widget.styles["border_size"]} solid #{widget.styles["border_color"]}" if widget.styles["border_size"].present?
    retHash["fixed-position"] = widget.styles["fixed_position"] if widget.styles["fixed_position"].present?
    # LEELEE: shadow
    # LEELEE: rounded
    hashToStyleString retHash
  end

end

