
Pod::Spec.new do |spec|

  spec.name         = "RZViewBuilderKit"
  spec.version      = "3.1.2"
  spec.summary      = "Small example to test code sharing."
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

  spec.source_files = "Sources/RZUIKit/RZViewBuilderKit/**/*"
  spec.exclude_files = "Sources/RZUIKit/RZViewBuilderKit/**/*.plist"
    
  spec.dependency 'RZDarkModeKit'
  spec.dependency 'RZObservableKit'
  spec.swift_version = '5.3'
  spec.ios.deployment_target  = '13.0'

  spec.requires_arc = true


end
