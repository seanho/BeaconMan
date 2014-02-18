Pod::Spec.new do |s|
  s.name             = "BeaconMan"
  s.version          = "0.1.0"
  s.summary          = "iBeacon"
  s.description      = <<-DESC
                       An easy to use iBeacon API
                       DESC
  s.license          = 'MIT'
  s.author           = { "Sean Ho" => "sean@seanho.net" }
  s.homepage         = 'https://github.com/seanho/BeaconMan'
  s.source           = { :git => "https://github.com/seanho/BeaconMan.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'Project/BeaconMan/Classes'
  # s.resources = 'Assets'

  # s.ios.exclude_files = 'Classes/osx'
  # s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'
  # s.dependency 'JSONKit', '~> 1.4'
end
