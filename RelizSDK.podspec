
Pod::Spec.new do |spec|

  spec.name         = "RelizSDK"
  spec.version      = "2.5.3"
  spec.summary      = "RelizSDK"
  spec.description  = "Small example to test code sharing via cocoapods."	
  
  spec.homepage     = "https://github.com/nersonSwift/RelizKit"

  spec.license      = "MIT"

  spec.author       = { 
	"Angel-senpai" => "daniil.murygin68@gmail.com", 
	"nersonSwift" => "aleksandrsenin@icloud.com" 
  }
 
  spec.source       = { 
	:git => "https://github.com/nersonSwift/RelizSDK.git", 
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
    ss.dependency 'RelizSDK/RZEventKit'
    ss.dependency 'RelizSDK/RZObservableKit'
    ss.dependency 'RelizSDK/RZDependencyKit'
  end

  spec.subspec 'RZUIKit' do |ss|
    ss.dependency 'RelizSDK/CoreOnly'
    ss.dependency 'RelizSDK/RZViewBuilderKit'
    ss.dependency 'RelizSDK/RZUIPacKit'
    ss.dependency 'RelizSDK/RZDarkModeKit'
    ss.dependency 'RelizSDK/RZAnimationKit'
  end

  spec.subspec 'RZViewBuilderKit' do |ss|
    ss.dependency 'RelizSDK/CoreOnly'
    ss.dependency "RZViewBuilderKit"
  end

  spec.subspec 'RZUIPacKit' do |ss|
    ss.dependency 'RelizSDK/CoreOnly'
    ss.dependency "RZUIPacKit"
  end

  spec.subspec 'RZDarkModeKit' do |ss|
    ss.dependency 'RelizSDK/CoreOnly'
    ss.dependency "RZDarkModeKit"
  end
  
  spec.subspec 'RZAnimationKit' do |ss|
    ss.dependency 'RelizSDK/CoreOnly'
    ss.dependency "RZAnimationKit"
  end

  spec.subspec 'RZStoreKit' do |ss|
    ss.dependency 'RelizSDK/CoreOnly'
    ss.dependency "RZStoreKit"
  end

  spec.subspec 'RZEventKit' do |ss|
    ss.dependency 'RelizSDK/CoreOnly'
    ss.dependency "RZEventKit"
  end
  
  spec.subspec 'RZObservableKit' do |ss|
    ss.dependency 'RelizSDK/CoreOnly'
    ss.dependency "RZObservableKit"
  end
  
  spec.subspec 'RZDependencyKit' do |ss|
    ss.dependency 'RelizSDK/CoreOnly'
    ss.dependency "RZDependencyKit"
  end

end
