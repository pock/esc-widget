# Uncomment the next line to define a global platform for your project
platform :osx, '10.15'

target 'Esc' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Esc
  pod 'PockKit', :git => 'https://github.com/pock/pockkit.git', :tag => '0.3.1'

end

# PockKit and some of its dependencies declare deployment targets older than the one this project supports
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      deployment_target = config.build_settings['MACOSX_DEPLOYMENT_TARGET']
      if deployment_target.nil? || Gem::Version.new(deployment_target) < Gem::Version.new('10.15')
        config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.15'
      end
    end
  end
end
