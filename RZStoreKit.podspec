
Pod::Spec.new do |spec|

  spec.name         = "RZStoreKit"
  spec.version      = "1.0.3"
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

  spec.source_files = "RZStoreKit/RZStoreKit/**/*"
  spec.exclude_files = "RZStoreKit/RZStoreKit/**/*.plist"
  spec.dependency "SwiftyStoreKit"
  spec.swift_version = '5.3'
  spec.ios.deployment_target  = '13.0'

  spec.requires_arc = true


end
