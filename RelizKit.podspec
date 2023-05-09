
Pod::Spec.new do |spec|

  spec.name         = "RelizKit"
  spec.version      = "6.0.4"
  spec.summary      = "RelizKit"
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

  spec.default_subspec = 'CoreOnly'
  
  spec.subspec 'CoreOnly' do |ss|
    ss.source_files = 'Sources/RelizKit/**/*'
    ss.exclude_files = 'Sources/RelizKit/**/*.plist'
    
  end
end
