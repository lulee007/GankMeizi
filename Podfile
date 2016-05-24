# Uncomment this line to define a global platform for your project
platform :ios, '8.0'

target 'GankMeizi' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'RxSwift',    '~> 2.0'
  pod 'RxCocoa',    '~> 2.0'
  pod 'EAIntroView', '~> 2.8.0'
  pod 'SwiftyUserDefaults'
  pod 'CocoaLumberjack/Swift'
  pod 'Alamofire', '~> 3.4'
  pod 'Moya'
  pod 'Moya/RxSwift'
  pod 'ObjectMapper', '~> 1.3'
  pod 'CHTCollectionViewWaterfallLayout/Swift', :git => 'git@github.com:chiahsien/CHTCollectionViewWaterfallLayout.git', :branch => 'develop'
  # SDWebImage used in MWPhotoBrowser so just replace kf to  SDWebImage
  # pod 'Kingfisher', '~> 2.4'
  pod 'SDWebImage', '~>3.7'
  pod 'MJRefresh'
  pod 'DZNEmptyDataSet'
  pod 'MWPhotoBrowser'

  # Pods for GankMeizi

  target 'GankMeiziTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', '~> 2.0'
    pod 'RxTests',    '~> 2.0'
  end

  target 'GankMeiziUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
