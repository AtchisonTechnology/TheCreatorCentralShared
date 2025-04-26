#
# Content

ContentType = %i[
    article
    podcast
    video
  ].freeze # Add more...
ContentStatus = %i[
    draft
    in_review
    publish
  ].freeze

ContentReadMoreMessages = {
  readmore: "Read More",
  contread: "Continue Reading",
  clickcontread: "Click to Continue Reading",
  readmorehere: "Click to Read More Here",
  continue: "Click Here to Continue",
  readrest: "Click To Read The Rest",
  readhere: "Read the Rest of the Article Here",
  custom: "<custom message>",
}

PublicationUriFormats=%i[flat pub cat pubcat].freeze