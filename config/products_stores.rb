#
# Products
#
ProductType = %i[
  book
  audiovideo
  course
  download
  physical
  inperson
  call
  other
].freeze
ProductStatus = %i[
  draft
  in_review
  ready
].freeze

#
# Listings
#
ListingUriFormats=%i[flat store cat storecat].freeze
ListingStatus = %i[in_review listed].freeze

#
# Store Product List Widget
#
StoreProductListDisplayStyles = [
  :image_left,
  :image_right,
  :image_top,
  :image_left_alternating,
  :image_right_alternating,
].freeze
