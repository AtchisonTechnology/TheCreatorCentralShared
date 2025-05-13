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
    ret["tcc_widget_classes"] = tcc_widget_classes
    self.render_inherited ret
    ret
  end

  def render_inherited hash
  end


  private

  def tcc_widget_outer
    retHash = {}
    # retHash["width"] = "100%"
    hashToStyleString retHash
  end
  def tcc_widget
    retHash = {}
    retHash["width"] = widget.styles["width"] if widget.styles["width"].present?
    retHash["color"] = widget.styles["text_color"] if widget.styles["text_color"].present?
    retHash["margin-top"] = widget.styles["margin_top"] if widget.styles["margin_top"].present?
    retHash["margin-right"] = widget.styles["margin_right"] if widget.styles["margin_right"].present?
    retHash["margin-bottom"] = widget.styles["margin_bottom"] if widget.styles["margin_bottom"].present?
    retHash["margin-left"] = widget.styles["margin_left"] if widget.styles["margin_left"].present?
    retHash["padding-top"] = widget.styles["padding_top"] if widget.styles["padding_top"].present?
    retHash["padding-right"] = widget.styles["padding_right"] if widget.styles["padding_right"].present?
    retHash["padding-bottom"] = widget.styles["padding_bottom"] if widget.styles["padding_bottom"].present?
    retHash["padding-left"] = widget.styles["padding_left"] if widget.styles["padding_left"].present?
    retHash["border"] = "#{widget.styles["border_size"]} solid #{widget.styles["border_color"]}" if widget.styles["border_size"].present?
    retHash["fixed-position"] = widget.styles["fixed_position"] if widget.styles["fixed_position"].present?
    if widget.styles["background"] == "color"
      retHash["background-color"]=widget.styles['background_color']
    elsif widget.styles["background"] == "image"
      retHash["background-image"]="url(#{widget.background_image.url})"
      retHash["background-position"]=widget.styles['background_position'].gsub(/_/,' ')
      retHash["background-repeat"]=widget.styles['background_tile'].gsub(/_/,'-')
      retHash["background-attachment"]=widget.styles['background_attachment']
      retHash["background-size"]=widget.styles['background_size']
      retHash["background-color"]=widget.styles['background_color']
    end
    hashToStyleString retHash
  end

  def tcc_widget_classes
    retClasses = []
    if widget.styles["fly_in"] == "fromleft"
      retClasses << "tcc_fly_in"
      retClasses << "tcc_fly_in_from_left"
    elsif widget.styles["fly_in"] == "fromright"
      retClasses << "tcc_fly_in"
      retClasses << "tcc_fly_in_from_right"
    elsif widget.styles["fly_in"] == "frombottom"
      retClasses << "tcc_fly_in"
      retClasses << "tcc_fly_in_from_bottom"
    end
    retClasses.join(' ')
  end
end

