
Pod::Spec.new do |spec|

  spec.name         = "RelizSDK"
  spec.version      = "1.1"
  spec.summary      = "RelizSDK"
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

  spec.swift_version = '5.3'
  spec.ios.deployment_target  = '13.0'

  spec.requires_arc = true

  spec.default_subspec = 'Core'
  
  spec.subspec 'CoreOnly' do |ss|
    ss.dependency "RelizKit"
  end

  spec.subspec 'Core' do |ss|
    ss.dependency 'RelizSDK/CoreOnly'
    ss.dependency 'RelizSDK/RZUIKit'
    ss.dependency 'RelizSDK/RZStoreKit'
    ss.dependency 'RelizSDK/RZEvent'
    ss.dependency 'RelizSDK/RZObservableKit'
  end

  spec.subspec 'RZUIKit' do |ss|
    ss.dependency 'RelizSDK/CoreOnly'
    ss.dependency 'RelizSDK/RZViewBuilder'
    ss.dependency 'RelizSDK/RZUIPacKit'
    ss.dependency 'RelizSDK/RZDarkModeKit'
  end

  spec.subspec 'RZViewBuilder' do |ss|
    ss.dependency 'RelizSDK/CoreOnly'
    ss.dependency "RZViewBuilder"
  end

  spec.subspec 'RZUIPacKit' do |ss|
    ss.dependency 'RelizSDK/CoreOnly'
    ss.dependency "RZUIPacKit"
  end

  spec.subspec 'RZDarkModeKit' do |ss|
    ss.dependency 'RelizSDK/CoreOnly'
    ss.dependency "RZDarkModeKit"
  end

  spec.subspec 'RZStoreKit' do |ss|
    ss.dependency 'RelizSDK/CoreOnly'
    ss.dependency "RZStoreKit"
  end

  spec.subspec 'RZEvent' do |ss|
    ss.dependency 'RelizSDK/CoreOnly'
    ss.dependency "RZEvent"
  end
  
  spec.subspec 'RZObservableKit' do |ss|
    ss.dependency 'RelizSDK/CoreOnly'
    ss.dependency "RZObservableKit"
  end

end