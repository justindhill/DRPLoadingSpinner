
Pod::Spec.new do |s|

  s.name         = "DRPLoadingSpinner"
  s.version      = "1.0.0"
  s.summary      = "A loading spinner that's strikingly Material-like."

  s.description  = <<-DESC
	"A loading spinner that's strikingly Material-like."
  DESC

  s.homepage     = "https://github.com/justindhill/DRPLoadingSpinner"
  s.screenshots  = "http://zippy.gfycat.com/RealExcitableBoubou.gif"

  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author       = { "Justin Hill" => "jhill.d@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/justindhill/DRPLoadingSpinner.git", :tag => s.version }
  s.source_files = "src", "src/*.{h,m}"

end
