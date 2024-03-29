Pod::Spec.new do |s|
  s.name         = 'UBICoreData'
  s.version      = '0.0.8'
  s.summary      = 'CoreData wrapper for iOS'
  s.homepage     = 'https://github.com/ubiregiinc/UBICoreData'
  s.license      = { :type => 'MIT' }
  s.author       = { 'Yuki Yasoshima' => 'yasoshima@ubiregi.com' }
  s.platform     = :ios, '12.0'
  s.requires_arc = true
  s.source       = { :git => 'https://github.com/ubiregiinc/UBICoreData.git', :tag => s.version.to_s }
  s.source_files = 'Sources/UBICoreData/*'
  s.framework    = 'CoreData'
end
