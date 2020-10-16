
Pod::Spec.new do |spec|

  spec.name         = "RelizKit"
  spec.version      = "1.2.1"
  spec.summary      = "Small example to test code sharing."
  spec.description  = "Small example to test code sharing via cocoapods."	
  
  spec.homepage     = "https://github.com/nersonSwift/RelizKit"

  spec.license      = "MIT"
  

 

  spec.author       = { "Angel-senpai" => "daniil.murygin68@gmail.com", "nersonSwift" => "aleksandrsenin@icloud.com" }
  spec.platform     = :ios, "13.0"
  spec.source       = { :git => "https://github.com/nersonSwift/RelizKit.git", :tag => "1.2.1" }

  # spec.source_files  = "RelizKit/**/*"
  spec.exclude_files = "RelizKit/**/*.plist"
  spec.swift_version = '5.3'
  spec.ios.deployment_target  = '13.0'

  spec.requires_arc = true

  spec.default_subspec = 'Core'

  spec.subspec 'Core' do |core|
    core.source_files   = 'RelizKit/Core/**/*'
    core.dependency 'RelizKit/RZUIKit'
    core.dependency 'RelizKit/RZStoreKit'
  end

  spec.subspec 'RZUIKit' do |uikit|
    uikit.dependency 'RelizKit/RZViewBuilder'
    uikit.dependency 'RelizKit/RZScreensKit'
  end

  spec.subspec 'RZViewBuilder' do |viewbuilder|
    viewbuilder.source_files = 'RelizKit/RZUIKit/RZViewBuilder/**/*'
    viewbuilder.dependency "SVGKit"
  end

  spec.subspec 'RZScreensKit' do |screens|
    screens.source_files = 'RelizKit/RZUIKit/RZScreensKit/**/*'
    
  end

  spec.subspec 'RZStoreKit' do |storekit|
    storekit.source_files = 'RelizKit/RZStoreKit/**/*'
    storekit.dependency "SwiftyStoreKit"
  end

end