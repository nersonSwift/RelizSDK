
Pod::Spec.new do |spec|

  spec.name         = "RelizKit"
  spec.version      = "2.0.2"
  spec.summary      = "RelizKit"
  spec.description  = "Small example to test code sharing via cocoapods."	
  
  spec.homepage     = "https://github.com/nersonSwift/RelizKit"

  spec.license      = "MIT"

  spec.author       = { 
	"Angel-senpai" => "daniil.murygin68@gmail.com", 
	"nersonSwift" => "aleksandrsenin@icloud.com" 
  }
 
  spec.source       = { 
	:git => "https://github.com/nersonSwift/RelizKit.git", 
	:tag => spec.name.to_s + "_v" + spec.version.to_s
  }

  spec.exclude_files = "RelizKit/**/*.plist"
  spec.swift_version = '5.3'
  spec.ios.deployment_target  = '13.0'

  spec.requires_arc = true

  spec.default_subspec = 'Core'
  
  spec.subspec 'CoreOnly' do |ss|
    ss.source_files = 'RelizKit/RelizKit/Core/RelizKit.h'
    ss.preserve_paths = 'RelizKit/RelizKit/Core/module.modulemap'
    
    ss.user_target_xcconfig = {
        'HEADER_SEARCH_PATHS' => "$(inherited) ${PODS_ROOT}/RelizKit/RelizKit/RelizKit/Core"
    }
    
  end

  spec.subspec 'Core' do |ss|
    ss.dependency 'RelizKit/CoreOnly'
    ss.dependency 'RelizKit/RZUIKit'
    ss.dependency 'RelizKit/RZStoreKit'
    ss.dependency 'RelizKit/RZEvent'
  end

  spec.subspec 'RZUIKit' do |ss|
    ss.dependency 'RelizKit/CoreOnly'
    ss.dependency 'RZUIKit'
    ss.source_files = 'RelizKit/RZUIKit/RZOperators/RZOperators.swift'
  end

  spec.subspec 'RZViewBuilder' do |ss|
    ss.dependency 'RelizKit/CoreOnly'
    ss.dependency "RZViewBuilder"
    ss.source_files = 'RelizKit/RZUIKit/RZOperators/RZOperators.swift'
  end

  spec.subspec 'RZScreensKit' do |ss|
    ss.dependency 'RelizKit/CoreOnly'
    ss.dependency "RZScreensKit"
  end

  spec.subspec 'RZDarkModeKit' do |ss|
    ss.dependency 'RelizKit/CoreOnly'
    ss.dependency "RZDarkModeKit"
    ss.source_files = 'RelizKit/RZUIKit/RZOperators/RZOperators.swift'
  end

  spec.subspec 'RZStoreKit' do |ss|
    ss.dependency 'RelizKit/CoreOnly'
    ss.dependency "RZStoreKit"
  end

  spec.subspec 'RZEvent' do |ss|
    ss.dependency 'RelizKit/CoreOnly'
    ss.dependency "RZEvent"
  end

end