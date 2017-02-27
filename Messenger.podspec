Pod::Spec.new do |s|
  s.name = 'Messenger'
  s.version = '0.9.0'
  s.license = 'MIT'
  s.summary = 'A swifty messenger!'
  s.homepage = 'https://github.com/JayJayy/Messenger'
  s.authors = { 'Johannes Starke' => 'johannesstarke@gmail.com' }
  s.source = { :git => 'https://github.com/JayJayy/Messenger.git', :tag => s.version }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'

  s.source_files = 'Messenger/Messenger/*.swift'
end
