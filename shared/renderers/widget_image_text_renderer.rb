class WidgetImageTextRenderer < WidgetBaseRenderer
  def render_inherited hash
    hash["img"] = img_widget
    hash["img_url"] = widget.image.url
  end

  private
  def img_widget
    retHash = {}
    retHash["width"] = widget.styles["image_width"] if widget.styles["image_width"].present?
    retHash["height"] = widget.styles["image_height"] if widget.styles["image_height"].present?
    retHash["float"] = widget.styles["image_float"] if widget.styles["image_float"].present?
    hashToStyleString retHash
  end
end
