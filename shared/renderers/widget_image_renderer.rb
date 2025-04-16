class WidgetImageRenderer < WidgetBaseRenderer
  def render_inherited hash
    hash["img"] = img_widget
    hash["img_url"] = widget.image.url
  end

  private
  def img_widget
    retHash = {}
    retHash["width"] = widget.styles["image_width"] if widget.styles["image_width"].present?
    retHash["height"] = widget.styles["image_height"] if widget.styles["image_height"].present?
    retHash["display"] = 'block'
    case widget.styles["image_align"]
    when 'left'
    retHash["margin-right"] = 'auto'
    when 'right'
      retHash["margin-left"] = 'auto'
    else
      retHash["margin-left"] = 'auto'
      retHash["margin-right"] = 'auto'
    end
    # retHash["image-align"] = widget.styles["image_align"] if widget.styles["image_align"].present?
    hashToStyleString retHash
  end
end
