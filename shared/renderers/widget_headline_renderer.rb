class WidgetHeadlineRenderer < WidgetBaseRenderer
  def render_inherited hash
    hash["level"] = level_widget
    hash["div"] = div_widget
  end

  private
  def level_widget
    widget.styles["headline_level"]
  end
  def div_widget
    retHash = {}
    retHash["font-family"] = widget.styles["font_family"] if widget.styles["font_family"].present?
    retHash["font-size"] = widget.styles["font_size"] if widget.styles["font_size"].present?
    retHash["line-height"] = widget.styles["line_height"] if widget.styles["line_height"].present?
    hashToStyleString retHash
  end
end
