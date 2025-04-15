class PageRenderer #< BaseRenderer
  attr_reader :page

  def initialize(page)
    @page = page
    super()
  end

  def render
    ret = {}
    ret
  end
end

