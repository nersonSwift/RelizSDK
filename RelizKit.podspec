
Pod::Spec.new do |spec|

  spec.name         = "RelizKit"
  spec.version      = "1.6"
  spec.summary      = "Small example to test code sharing."
  spec.description  = "Small example to test code sharing via cocoapods."	
  
  spec.homepage     = "https://github.com/nersonSwift/RelizKit"

  spec.license      = "MIT"
  

 

  spec.author       = { "Angel-senpai" => "daniil.murygin68@gmail.com", "nersonSwift" => "aleksandrsenin@icloud.com" }
 
  spec.source       = { :git => "https://github.com/nersonSwift/RelizKit.git", :tag => "1.6" }

  spec.exclude_files = "RelizKit/**/*.plist"
  spec.swift_version = '5.3'
  spec.ios.deployment_target  = '13.0'

  spec.requires_arc = true

  spec.default_subspec = 'Core'
  
  spec.subspec 'CoreOnly' do |ss|
    ss.source_files = 'RelizKit/Core/**/*'
  end

  spec.subspec 'Core' do |ss|
    ss.dependency 'RelizKit/CoreOnly'
    ss.dependency 'RelizKit/RZUIKit'
    ss.dependency 'RelizKit/RZStoreKit'
    ss.dependency 'RelizKit/RZEvent'
  end

  spec.subspec 'RZUIKit' do |ss|
    ss.dependency 'RelizKit/CoreOnly'
    ss.dependency 'RelizKit/RZViewBuilder'
    ss.dependency 'RelizKit/RZScreensKit'
  end

  spec.subspec 'RZViewBuilder' do |ss|
    ss.dependency 'RelizKit/CoreOnly'
    ss.dependency 'RelizKit/RZDarkModeKit'
    ss.dependency "SVGKit"
    ss.source_files = 'RelizKit/RZUIKit/RZViewBuilder/**/*'
  end

  spec.subspec 'RZScreensKit' do |ss|
    ss.dependency 'RelizKit/CoreOnly'
    ss.source_files = 'RelizKit/RZUIKit/RZScreensKit/**/*'
  end

  spec.subspec 'RZDarkModeKit' do |ss|
    ss.dependency 'RelizKit/CoreOnly'
    ss.dependency "RZDarkModeKit"
  end

  spec.subspec 'RZStoreKit' do |ss|
    ss.source_files = 'RelizKit/RZStoreKit/**/*'
    ss.dependency "SwiftyStoreKit"
    ss.dependency 'RelizKit/CoreOnly'
  end

  spec.subspec 'RZEvent' do |ss|
    ss.source_files = 'RelizKit/RZEvent/**/*'
    ss.dependency 'RelizKit/CoreOnly'
  end

end