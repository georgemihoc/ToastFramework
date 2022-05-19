Pod::Spec.new do |s|
  s.name             = "ToastFrameworkSwift"
  s.version          = "1.0.3"
  s.summary          = "ToastFrameworkSwift Library"
  s.description      = <<-DESC
  A simple and useful toast framework written in Swift.
  DESC
  s.homepage         = "https://github.com/georgemihoc/ToastFramework"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "George Mihoc" => "george.mihoc@gmail.com" }
  s.platform         = :ios, "13.0"
  s.swift_versions   = "5.0"
  s.source           = { :git => "https://github.com/georgemihoc/ToastFramework.git", :tag => "#{s.version}" }
  s.source_files     = "ToastFramework/**/*"
end
