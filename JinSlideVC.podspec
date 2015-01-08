Pod::Spec.new do |s|

  s.name         = "JinSlideVC"
  s.version      = "1.0.1"
  s.summary      = "A slide page view."
  s.homepage     = "https://github.com/JxbSir/JinSlideVC.git"
  s.license      = "JXB"
  s.author       = { "Peter" => "i@jxb.name" }
  s.requires_arc = true
  s.source       = { :git => "https://github.com/JxbSir/JinSlideVC.git", :commit => "04a8046af9d1e76fd9f2ed19c81157a43ced7add" }
  s.source_files = "JinSlideView/*.{h,m}"

end
