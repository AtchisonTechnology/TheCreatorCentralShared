#
# Usage:
#   In model:
#     include SettingsStylesMgmt
#     settings_accessor :attr1, :attr2, :attr3
#     styles_accessor :attr1, :attr2, :attr3
#   In controller's model_params method, one (only) of these:
#     params.require(:model).permit(Model.settings_permits(:other,:model,:attributes))
#     params.require(:model).permit(Model.styles_permits(:other,:model,:attributes))
#     params.require(:model).permit(Model.settings_styles_permits(:other,:model,:attributes))
#
module SettingsStylesMgmt
  extend ActiveSupport::Concern
  included do
    include HstoreMgmt
    #
    #
    # Settings
    #
    #
    def self.settings_accessor *attrs
      self.hstore_accessor :settings,*attrs
    end
    def self.settings_bool_accessor *attrs
      self.hstore_bool_accessor :settings,*attrs
    end
    def self.settings_json_accessor *attrs
      self.hstore_json_accessor :settings,*attrs
    end
    def self.settings_attrs_list
      self.hstore_attrs_list :settings
    end
    def self.settings_permits *attrs
      self.hstore_permits :settings,*attrs
    end
    #
    #
    # Styles
    #
    #
    def self.styles_accessor *attrs
      self.hstore_accessor :styles,*attrs
    end
    def self.styles_attrs_list
      self.hstore_attrs_list :styles
    end
    def self.styles_permits *attrs
      self.hstore_permits :styles,*attrs
    end
    #
    #
    # Settings/Styles
    #
    #
    def self.settings_styles_permits *attrs
      attrs+self.hstore_attrs_list(:settings)+self.hstore_attrs_list(:styles)
    end
  end

end