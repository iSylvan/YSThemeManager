Pod::Spec.new do |s|
  s.name         = "YSThemeManager"
  s.version      = "1.0.1"
  s.summary      = "ThemeManager"
  s.homepage     = "https://github.com/iSylvan/YSThemeManager"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "sylvan" => "yanshan.cool@gmial.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "git@github.com:iSylvan/YSThemeManager.git", :tag => s.version }
  
  s.requires_arc = true

  s.source_files = 'YSThemeManager/**/*.{h,m}'
  s.resource     = 'YSThemeManager/Assets/*.plist'
  
  # s.subspec 'Core' do |ss|
  #   ss.source_files = 'YSThemeManager/Core/**/*'
  #   ss.public_header_files = 'YSThemeManager/Core/**/*.{h}'
  # end

end
