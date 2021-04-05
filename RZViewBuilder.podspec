
Pod::Spec.new do |spec|

  spec.name         = "RZViewBuilder"
  spec.version      = "2.4"
  spec.summary      = "Small example to test code sharing."
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

  spec.source_files = "RZUIKit/RZViewBuilder/RZViewBuilder/**/*"
  spec.exclude_files = "RZUIKit/RZViewBuilder/RZViewBuilder/**/*.plist"
    
  spec.dependency 'RZDarkModeKit'
  spec.dependency 'RZObservableKit'
  spec.swift_version = '5.3'
  spec.ios.deployment_target  = '13.0'

  spec.requires_arc = true


end