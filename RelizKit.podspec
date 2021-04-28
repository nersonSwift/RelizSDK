
Pod::Spec.new do |spec|

  spec.name         = "RelizKit"
  spec.version      = "5.1"
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
    ss.source_files = 'CoreOnly/RelizKit.h'
    ss.preserve_paths = 'CoreOnly/**/*'
    
    ss.user_target_xcconfig = {
        'HEADER_SEARCH_PATHS' => "$(inherited) ${PODS_ROOT}/RelizKit/CoreOnly"
    }
    
  end

  spec.subspec 'Core' do |ss|
    ss.dependency 'RelizKit/CoreOnly'
    ss.dependency 'RelizKit/RZUIKit'
    ss.dependency 'RelizKit/RZStoreKit'
    ss.dependency 'RelizKit/RZEvent'
    ss.dependency 'RelizKit/RZObservableKit'
  end

  spec.subspec 'RZUIKit' do |ss|
    ss.dependency 'RelizKit/CoreOnly'
    ss.dependency 'RelizKit/RZViewBuilder'
    ss.dependency 'RelizKit/RZUIPacKit'
    ss.dependency 'RelizKit/RZDarkModeKit'
  end

  spec.subspec 'RZViewBuilder' do |ss|
    ss.dependency 'RelizKit/CoreOnly'
    ss.dependency "RZViewBuilder"
  end

  spec.subspec 'RZUIPacKit' do |ss|
    ss.dependency 'RelizKit/CoreOnly'
    ss.dependency "RZUIPacKit"
  end

  spec.subspec 'RZDarkModeKit' do |ss|
    ss.dependency 'RelizKit/CoreOnly'
    ss.dependency "RZDarkModeKit"
  end

  spec.subspec 'RZStoreKit' do |ss|
    ss.dependency 'RelizKit/CoreOnly'
    ss.dependency "RZStoreKit"
  end

  spec.subspec 'RZEvent' do |ss|
    ss.dependency 'RelizKit/CoreOnly'
    ss.dependency "RZEvent"
  end
  
  spec.subspec 'RZObservableKit' do |ss|
    ss.dependency 'RelizKit/CoreOnly'
    ss.dependency "RZObservableKit"
  end

end