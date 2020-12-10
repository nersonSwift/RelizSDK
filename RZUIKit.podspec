
Pod::Spec.new do |spec|

  spec.name         = "RZUIKit"
  spec.version      = "2.0"
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

  spec.source_files = "RZUIKit/RZUIKit/RZUIKit/RZUIKit.h"
  spec.preserve_paths = 'RZUIKit/RZUIKit/RZUIKit/module.modulemap'
  spec.exclude_files = "RZUIKit/RZUIKit/RZUIKit/**/*.plist"
  spec.swift_version = '5.3'
  spec.ios.deployment_target  = '13.0'

  spec.user_target_xcconfig = {
        'HEADER_SEARCH_PATHS' => "$(inherited) ${PODS_ROOT}/RZUIKit/RZUIKit/RZUIKit/RZUIKit"
    }

  spec.requires_arc = true

  spec.dependency "RZScreensKit"
  spec.dependency "RZViewBuilder"
end