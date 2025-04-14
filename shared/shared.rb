require_rel './shared/'
#require_rel './renderers/'

require_rel '../config/styles.rb'

StylesConfig = BaseStyles.merge(YAML::load(File.read("#{TheCreatorCentralShared}/config/styles.yml"))).deep_symbolize_keys
SocialConfig = YAML::load(File.read("#{TheCreatorCentralShared}/config/social.yml")).deep_symbolize_keys
SubscriptionPackages = YAML::load(File.read("#{TheCreatorCentralShared}/config/subscription_packages.yml")).deep_symbolize_keys
WidgetsAndLayoutConfig = YAML::load(File.read("#{TheCreatorCentralShared}/config/widgets_and_layouts.yml")).deep_symbolize_keys
WidgetInfo = WidgetsAndLayoutConfig[:widgets]
PageLayoutInfo = WidgetsAndLayoutConfig[:page_layouts]
SharedAppConfig = {}.merge(YAML::load(File.read("#{TheCreatorCentralShared}/config/shared_configuration.yml"))["shared"]||{bad: :stuff})
                    .merge(YAML::load(File.read("#{TheCreatorCentralShared}/config/shared_configuration.yml"))[CurrentEnvironment]||{bad: :stuff})
                    .deep_symbolize_keys
