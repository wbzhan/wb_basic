
Pod::Spec.new do |s|
s.name             = 'wb_basic'
s.version          = '0.1.3'
s.summary          = 'basic classes'


s.description      = <<-DESC
部分基类、网络控件、自定义部分View
DESC

s.homepage         = 'https://github.com/wbzhan/wb_basic.git'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'wbzhan' => 'wbzhan@yeah.net.com' }
s.source           = { :git => 'https://github.com/wbzhan/wb_basic.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.swift_version = '5.0'
s.ios.deployment_target = '10.0'

s.source_files = 'wb_basic/Classes/**/*'

# s.resource_bundles = {
#   'wb_basic' => ['wb_basic/Assets/*.png']
# }

# s.frameworks = 'UIKit', 'MapKit'
s.dependency 'Moya/RxSwift', '~> 14.0.0'
s.dependency 'MBProgressHUD','1.1.0'
#刷新控件
s.dependency 'MJRefresh'
#RX
s.dependency 'RxSwift', '~> 5'
s.dependency 'RxCocoa', '~> 5'
s.dependency 'RxDataSources', '~> 4.0'
#约束
s.dependency 'SnapKit', '~> 5.0.1'
# HandyJson
s.dependency 'HandyJSON', '~> 5.0.3-beta'
#扩展
s.dependency 'kit_extension'
#图片加载
s.dependency 'Kingfisher', '~> 5.15.8'
#数据库
s.dependency 'FMDB'
end
