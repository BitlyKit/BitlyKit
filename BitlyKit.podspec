Pod::Spec.new do |s|
  s.name = 'BitlyKit'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'Bitly client for public Bitly API'
  s.homepage = 'https://github.com/BitlyKit/BitlyKit'
  s.social_media_url = 'http://twitter.com/smallsharptools'
  s.authors = { 'Brennan Stehling' => 'brennan@smallsharptools.com' }
  s.source = { :git => 'https://github.com/BitlyKit/BitlyKit.git', :tag => s.version }

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'Source/*.swift'
end
