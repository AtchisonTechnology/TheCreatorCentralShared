require_rel '../config/'
StylesConfig = BaseStyles.merge(YAML::load(File.read("#{TheCreatorCentralShared}/config/styles.yml"))).deep_symbolize_keys
SocialConfig = YAML::load(File.read("#{TheCreatorCentralShared}/config/social.yml")).deep_symbolize_keys
SubscriptionPackages = YAML::load(File.read("#{TheCreatorCentralShared}/config/subscription_packages.yml")).deep_symbolize_keys
WidgetsAndLayoutConfig = YAML::load(File.read("#{TheCreatorCentralShared}/config/widgets_and_layouts.yml")).deep_symbolize_keys
WidgetInfo = WidgetsAndLayoutConfig[:widgets]
PageLayoutInfo = WidgetsAndLayoutConfig[:page_layouts]
SharedAppConfig = {}.merge(YAML::load(File.read("#{TheCreatorCentralShared}/config/shared_configuration.yml"))["shared"]||{bad: :stuff})
                    .merge(YAML::load(File.read("#{TheCreatorCentralShared}/config/shared_configuration.yml"))[CurrentEnvironment]||{bad: :stuff})
                    .deep_symbolize_keys
require_rel './shared/hstore_mgmt'
require_rel './shared/settings_styles_mgmt'
require_rel './shared/'
require_rel './renderers/'

#
# Themes
#
ThemeConfig = {}
print("Loading themes...\n")
Dir.glob("#{TheCreatorCentralShared}/themes/**/theme-*.yml").each do |file|
  theme_id = File.basename(file).gsub(/^theme-/,'').gsub(/\.yml$/,'')
  yml = YAML::load(File.read(file))
  unless yml[theme_id].present?
    print(">>>> Theme ERROR [#{theme_id}]: Can't locate configuration in #{yml.inspect}\n")
    next
  end
  unless File.file?("#{TheCreatorCentralShared}/themes/theme-#{theme_id}.js")
    print(">>>> Theme ERROR [#{theme_id}]: Can't locate theme-#{theme_id}.js\n")
    next
  end
  unless File.file?("#{TheCreatorCentralShared}/themes/theme-#{theme_id}.css")
    print(">>>> Theme ERROR [#{theme_id}]: Can't locate theme-#{theme_id}.css\n")
    next
  end
  ThemeConfig.merge!(theme_id=>yml[theme_id])
  print("     Theme [#{theme_id}] loaded: #{yml[theme_id]["name"]}\n")
end
ThemeConfig.deep_symbolize_keys!
