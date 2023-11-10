
Pod::Spec.new do |s| 

  s.name         = "CodeAny"
  s.version      = "0.2.0"
  s.summary      = " swift codable 支持泛型类型 "

  s.description  = <<-DESC
  用于swift codable可以支持泛型类型
                   DESC

  s.homepage     = "https://github.com/zhtut/CodeAny.git"

  s.license        = { :type => 'MIT', :file => 'LICENSE' }

  s.author             = { "zhtg" => "zhtg@icloud.com" }

  s.source       = { :git => "https://github.com/zhtut/CodeAny.git", :tag => "#{s.version}" }

  s.source_files  = "Sources/**/*.swift"
  s.module_name   = 'CodeAny'

  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = '10.12'

end
