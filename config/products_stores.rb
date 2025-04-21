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
  :flat_list,
  :med_image_alternate
].freeze
