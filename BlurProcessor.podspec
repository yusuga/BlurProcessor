Pod::Spec.new do |s|
  s.name = 'BlurProcessor'
  s.version = '0.0.1'
  s.summary = 'Blur processing of UIImage. It works smoothly even at a low spec devices.'
  s.homepage = 'https://github.com/yusuga/BlurProcessor'
  s.license = 'MIT'
  s.author = 'Yu Sugawara'
  s.source = { :git => 'https://github.com/yusuga/BlurProcessor.git', :tag => s.version.to_s }
  s.platform = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.source_files = 'Classes/BlurProcessor/*.{h,m}'
  s.requires_arc = true
  s.compiler_flags = '-fmodules'
end