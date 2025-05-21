MetricEntryHitTypes = [
  :page,
  :download,
  :ext_link,
  :robots,
  :sitemap,
  :rss,
  :redirect,
  :raw_404, # A 404 that was not picked up by a page handler...
].freeze
MetricEntryHttpAccessMethods = [
  :get,
  :post,
  :put,
  :patch,
  :delete,
  :head,
  :options,
].freeze