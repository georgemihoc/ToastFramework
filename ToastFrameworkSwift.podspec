Pod::Spec.new do |spec|

  spec.name             = "ToastFrameworkSwift"
  spec.version          = "1.0.2"
  spec.summary          = "A toast framework written in Swift."

  spec.description      = <<-DESC
    A simple and useful toast framework written in Swift.
                   DESC

  spec.homepage         = "https://github.com/georgemihoc/ToastFramework"
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { "George Mihoc" => "george.mihoc@gmail.com" }
  spec.platform         = :ios
  spec.platform         = :ios, "13.0"
  spec.swift_versions   = ['5.0']
  spec.source           = { :git => "https://github.com/georgemihoc/ToastFramework.git", :tag => "#{spec.version}" }
  spec.source_files     = "ToastFramework/**/*"
end
