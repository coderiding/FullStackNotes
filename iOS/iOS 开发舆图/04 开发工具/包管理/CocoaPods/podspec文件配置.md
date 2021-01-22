## 参考配置a

```
Pod::Spec.new do |s| 
  s.name              = "Foundation-pd" 
  s.version           = "0.1.0" 
  s.summary           = "Powerdata Foundation for iOS Team" 
  s.homepage          = "<http://blog.devzeng.com>" 
  s.license                 = { :type => 'MIT', :file => 'LICENSE' } 
  s.author            = { "zengjing" => "hhtczengjing@gmail.com" } 
  s.source            = { :git => "YOUR_REPO_URL", :tag => "#{s.version}" } 
  s.default_subspec   = 'Core' 
  s.platform          = :ios, "7.0" 
  s.requires_arc      = true 
  s.framework         = 'UIKit' 

  s.subspec 'Core' do |ss| 
    ss.source_files = "Pod/Classes/{Core,Util}/**/*.{h,m,mm,c}" 
  end 

  s.subspec 'CrashReporter' do |ss| 
    ss.source_files = "Pod/Classes/CrashReporter/**/*.{h,m,mm,c}" 
    ss.dependency 'PLCrashReporter', '~> 1.2.0' 
  end 

  s.subspec 'DB' do |ss| 
    ss.source_files = "Pod/Classes/DB/**/*.{h,m,mm,c}" 
    ss.dependency 'Foundation-pd/Core' 
    ss.dependency 'FMDB', '~> 2.6.2' 
    ss.dependency 'FMDBMigrationManager', '~> 1.4.1' 
  end 

  s.subspec 'Logger' do |ss| 
    ss.source_files = "Pod/Classes/PDFoundation/src/Logger/**/*.{h,m,mm,c}" 
    ss.dependency 'Foundation-pd/Core' 
    ss.dependency 'CocoaLumberjack', '~> 2.2.0' 
  end 

  s.subspec 'UI' do |ss| 
    ss.source_files = "Pod/Classes/UI/**/*.{h,m,mm,c}" 
    ss.dependency 'Foundation-pd/Core' 
    ss.dependency 'Masonry', '~> 1.0.0' 
  end 

  s.subspec 'Model' do |ss| 
    ss.source_files = "Pod/Classes/Model/**/*.{h,m,mm,c}" 
    ss.dependency 'Foundation-pd/Core' 
    ss.dependency 'Mantle', '~> 2.0.7' 
    ss.dependency 'RPJSONValidator', '~> 0.2.0' 
    ss.dependency 'libextobjc', '~> 0.4.1' 
  end 

  s.subspec 'Store' do |ss| 
    ss.source_files = "Pod/Classes/Store/**/*.{h,m,mm,c}" 
    ss.dependency 'Foundation-pd/Core' 
    ss.dependency 'Foundation-pd/Network' 
  end 

  s.subspec 'Service' do |ss| 
    service.source_files = "Pod/Classes/Service/**/*.{h,m,mm,c}" 
    service.dependency 'Foundation-pd/Core' 
  end 
   
  s.subspec 'Network' do |ss| 
    ss.source_files = "Pod/Classes/Network/**/*.{h,m,mm,c}" 
    ss.dependency 'Foundation-pd/Core' 
    ss.dependency 'AFNetworking', '~> 2.5.4' 
  end 

  s.subspec 'WebService' do |ss| 
    ss.source_files = "Pod/Classes/WebService/**/*.{h,m,mm,c}" 
    ss.dependency 'Foundation-pd/Core' 
    ss.dependency 'AFNetworking', '~> 2.5.4' 
    ss.dependency 'KissXML', '~> 5.0.3' 
    ss.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' } 
  end 

  s.subspec 'Manager' do |ss| 
    ss.source_files = "Pod/Classes/Manager/**/*.{h,m,mm,c}" 
    ss.dependency 'Foundation-pd/Core' 
  end 

end 

```

## 参考配置b

```
Pod::Spec.new do |s| 
s.name          = 'YJDemoSDK' # 项目名 
s.version       = '0.1.0' # 相应的版本号 
s.summary       = 'A short description of YJDemoSDK.' # 简述 
s.description   = <<‐ DESC # 详细描述 
TODO: Add long description of the pod here. 
DESC 
s.homepage      = '<https://github.com/yangjie2/YJDemoSDK>' # 项目主页 
s.license       = { :type => 'MIT', :file => 'LICENSE' } # 开源协议 
s.author        = { 'yangjie2' => 'yangjie2@guahao.com' } # 作者 
s.platform      = :ios, '8.0' # 支持的平台 
s.requires_arc  = true #arc 和mrc选项 
s.libraries     = 'z', 'sqlite3' # 表示依赖的系统类库，比如libz.dylib等 
s.frameworks    = 'UIKit','AVFoundation' # 表示依赖系统的框架 
s.ios.vendored_frameworks = 'YJKit/YJKit.framework' # 依赖的第三方/自己的framework 
s.vendored_libraries = 'Library/Classes/libWeChatSDK.a' # 表示依赖第三方/自己的静态库（比如libWeChatSDK.a） 
# 依赖的第三方的或者自己的静态库文件必须以lib为前缀进行命名，否则会出现找不到的情况，这一点非常重要 

# 平台信息 
s.platform      = :ios, '7.0'  
s.ios.deployment_target = '7.0' 

# 文件配置项 
s.source        = { :git => '<https://github.com/yangjie2/YJDemoSDK.git>', :tag => s.version.to_s } 
  # 配置项目的目标路径，如果不是本地开发，pod init/update会从这个路去拉去代码 

s.source_files = 'YJDemoSDK/Classes/**/*.{h,m}' # 你的源码位置 
s.resources     = ['YJDemoSDK/Assets/*.png'] # 资源，比如图片，音频文件等 
s.public_header_files = 'YJDemoSDK/Classes/YJDemoSDK.h'   # 需要对外开放的头文件 

# 依赖的项目内容 可以多个 
s.dependency 'YYModel' 
s.dependency 'AFNetworking' '2.3 

```