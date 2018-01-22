Pod::Spec.new do |s|
  s.name             = 'EventBottle'
  s.version          = '0.1.0'
  s.summary          = 'In app event log recorder/viewer for debugging'
  s.homepage         = 'https://github.com/slightair/EventBottle'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tomohiro Moro' => 'arksutite@gmail.com' }
  s.source           = { :git => 'https://github.com/slightair/EventBottle.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'Sources/**/*'

  s.frameworks = 'UIKit'
end
