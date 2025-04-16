class WidgetSeparatorRenderer < WidgetBaseRenderer
  def render_inherited hash
    hash["hr"] = hr_widget
  end

  private
  def hr_widget
    retHash = {}
    retHash["border-style"] = widget.styles["border_style"] if widget.styles["border_style"].present?
    retHash["border-width"] = widget.styles["border_width"] if widget.styles["border_width"].present?
    hashToStyleString retHash
  end
end
