Pod::Spec.new do |spec|
  spec.name         = 'CSMediaPicker'
  spec.version      = '0.1.0'
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.homepage     = 'https://github.com/vcacic/CSMediaPicker'
  spec.authors      = { "Clover Studio" => "info@clover.studio" }
  spec.summary      = 'CSMediaPicker lets a user multiple select media from phone.'
  spec.source       = { :git => "https://github.com/vcacic/CSMediaPicker.git",
                        :tag => "#{spec.version}" }
  spec.source_files = 'CSMediaPicker/**/*.{swift}'
  spec.framework    = 'UIKit'
  spec.swift_version = "5.0"
  spec.requires_arc = true
  spec.ios.deployment_target = '13.0'
  spec.resources = ["CSMediaPicker/*.storyboard","CSMediaPicker/*.xib", "CSMediaPicker/*.xcassets"]
end