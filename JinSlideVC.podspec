Pod::Spec.new do |s|

  s.name         = "JinSlideVC"
  s.version      = "1.0.0"
  s.summary      = "A slide page view.”
  s.homepage     = "https://github.com/JxbSir/JinSlideVC.git"
  s.license      = "JXB"
  s.author       = { "Peter" => "i@jxb.name" }
  s.requires_arc = true
  s.source       = { :git => "https://github.com/JxbSir/JinSlideVC.git", :tag => “1.0.0” }

  s.public_header_files = 'JinSlideView/*.h’
  s.source_files = 'JinSlideView/JinSlideView.h’

end
