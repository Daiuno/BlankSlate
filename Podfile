source 'https://cdn.cocoapods.org/'

install! 'cocoapods',
  :generate_multiple_pod_projects => true,
  :share_schemes_for_development_pods => true

#use_frameworks!
#use_frameworks! :linkage => :static
use_frameworks! :linkage => :dynamic

workspace 'BlankSlate.xcworkspace'

target 'Example iOS' do
  platform :ios, '13.0'

  pod 'BlankSlate', :path => './'
#  pod 'FlyHUD'

  target 'Example Tests' do
    inherit! :search_paths
  end
end
target 'Example tvOS' do
  platform :tvos, '13.0'
  pod 'BlankSlate', :path => './'
#  pod 'FlyHUD'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
    end
  end
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
      end
    end
  end
end

post_integrate do |installer|
  installer.aggregate_targets.each do |aggregate_target|
    aggregate_target.user_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
      end
    end
    aggregate_target.user_project.save
  end
end
