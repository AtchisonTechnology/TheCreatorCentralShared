class WidgetMultiRenderer < WidgetBaseRenderer
  def render_inherited hash
    hash["outer_div"] = outer_div_widget
    col1=widget.styles["subwid_relwidth_1"].to_i
    hash["sub_1"] = "flex: #{col1} #{col1} #{col1}%"
    col2=widget.styles["subwid_relwidth_2"].to_i
    hash["sub_2"] = "flex: #{col2} #{col2} #{col2}%"
    col3=widget.styles["subwid_relwidth_3"].to_i
    hash["sub_3"] = "flex: #{col3} #{col3} #{col3}%"
  end

  private
  def outer_div_widget
    retHash = {}
    if widget.styles["subwidget_layout"] == 'side'
      retHash["display"] = 'flex'
      retHash["flex-flow"] = 'row wrap'
      retHash["justify-content"] = widget.styles["justify_content"] if widget.styles["justify_content"].present?
      retHash["align-items"] = widget.styles["align_items"] if widget.styles["align_items"].present?
      retHash["gap"] = widget.styles["subwidget_gap"] if widget.styles["subwidget_gap"].present?
    end
    hashToStyleString retHash
  end
end
