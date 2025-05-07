#
# Usage:
#   In model:
#     include HstoreMgmt
#     hstore_accessor :hstore_column_name, :attr1, :attr2, :attr3
#     hstore_bool_accessor :hstore_column_name, :attr1, :attr2, :attr3
#     hstore_json_accessor :hstore_column_name, :attr1, :attr2, :attr3
#     (any of the above hstore_*accessor lines)
#   In controller's model_params method:
#     params.require(:model).permit(Model.hstore_permits(:hstore_column_name,:other,:model,:attributes))
#   or:
#     params.expect(model:Model.hstore_permits(:hstore_column_name,:other,:model,:attributes))
#
module HstoreMgmt
  extend ActiveSupport::Concern
  included do
    #
    #
    # Generic HSTORE
    #
    #
    def self.hstore_accessor column, *attrs
      attrs = [attrs].flatten
      @hstore_accessor_list||={}
      @hstore_accessor_list[column.to_sym]||=[]
      @hstore_accessor_list[column.to_sym]+=attrs
      assign_column="#{column}="
      attrs.each do |attr|
        self.define_method attr do
          self.send(column)[attr.to_s].to_s
        end
        self.define_method "#{attr}=" do |val|
          self.send(column)[attr.to_s]=val.to_s
        end
        self.define_method "#{attr}?" do
          self.send(column)[attr.to_s].present?
        end
        self.define_method "clear_#{attr}" do
          self.send(column)[attr.to_s]=nil
        end
      end
    end
    def self.hstore_bool_accessor column,*attrs
      self.hstore_accessor column,*attrs
      assign_column="#{column}="
      [attrs].flatten.each do |attr|
        self.define_method "#{attr}_bool" do
          self.send(column)[attr.to_s].to_i != 0
        end
        self.define_method "#{attr}_bool=" do |val|
          self.send(column)[attr.to_s]= (!!val) ? '1' : '0'
        end
      end
    end
    def self.hstore_json_accessor column,*attrs
      self.hstore_accessor column,*attrs
      assign_column="#{column}="
      [attrs].flatten.each do |attr|
        self.define_method "#{attr}_json" do
          return {} unless self.send(column)[attr.to_s].present?
          JSON.parse(self.send(column)[attr.to_s].to_s)
        end
        self.define_method "#{attr}_json=" do |val|
          self.send(column)[attr.to_s]=val.to_json
        end
      end
    end
    def self.hstore_attrs_list column
      @hstore_accessor_list||={}
      @hstore_accessor_list[column.to_sym]||=[]
      @hstore_accessor_list[column.to_sym]
    end
    def self.hstore_permits columns_array, *attrs
      res = attrs
      [columns_array].flatten.each do |col|
        res+=self.hstore_attrs_list(col)
      end
      res
    end
  end
end