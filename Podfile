# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'wayUparty' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for wayUparty
    pod 'CHIPageControl/Jaloro'
    pod 'MSPeekCollectionViewDelegateImplementation'
    pod 'ShimmerSwift'
    pod 'ActiveLabel'
    pod 'pop', '~> 1.0'
    pod 'CCBottomRefreshControl'
    pod 'VTSwiftySlideMenu'
    pod 'AnimatedField'
    pod 'Stepperier'
    pod 'MarqueeLabel'
    pod 'AwaitToast'
    pod 'razorpay-pod'
    pod 'FSPagerView'
    pod 'ScrollingPageControl'
    pod 'SwiftyGif'
    pod 'Firebase/Analytics'
    pod 'Firebase/Messaging'
    pod 'Firebase/Core'
    pod 'AARatingBar'
    #pod 'FreshchatSDK'
    pod 'GooglePlaces'
    pod 'GoogleMaps'
    pod 'GoogleSignIn'
    pod 'Alamofire'
    pod 'Kingfisher', '~> 7.0'
    pod 'LabelSwitch'
    pod 'Mobilisten'
   
  target 'wayUpartyTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'wayUpartyUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end


post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.1'
               end
          end
   end
end
