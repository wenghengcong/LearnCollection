Pod::Spec.new do |s|
  s.name = "BFDynamicFramework"
  s.version = "0.0.1"
  s.summary = "build frameworks by cocoapods."
  s.license = "MIT"
  s.authors = {"wenghengcong"=>"wenghengcong@gamil.com"}
  s.homepage = "https://github.com/wenghengcong/BeeFunFeedback"
  s.description = "show you how to build frameworks by cocoapods"
  s.source = { :path => '.' }

  s.osx.deployment_target    = ''
  s.osx.vendored_framework   = 'osx/BFDynamicFramework.framework'
  s.ios.deployment_target    = ''
  s.ios.vendored_framework   = 'ios/BFDynamicFramework.framework'
  s.tvos.deployment_target    = ''
  s.tvos.vendored_framework   = 'tvos/BFDynamicFramework.framework'
  s.watchos.deployment_target    = ''
  s.watchos.vendored_framework   = 'watchos/BFDynamicFramework.framework'
end
