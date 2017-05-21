
Pod::Spec.new do |s|

  s.name         = "DRPLoadingSpinner"
  s.version      = "1.2.0"
  s.summary      = "A loading spinner/activity indicator and refresh control that's strikingly Material-like."

  s.description  = <<-DESC
	"DRPLoadingSpinner's default settings are very similar to how a Material spinner would look; however, it's very customizable and can express many different styles of spinner. Check out the readme for more info."
  DESC

  s.homepage     = "https://github.com/justindhill/DRPLoadingSpinner"
  s.screenshots  = ["https://camo.githubusercontent.com/de77faf4dea83039e9038cfe80b907602b52961d/687474703a2f2f696d6775722e636f6d2f635562654974462e676966", "https://camo.githubusercontent.com/56ea4e538c729d93e4fbd51e610ce4b9ff746284/687474703a2f2f696d6775722e636f6d2f575163677164662e676966"]

  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author       = { "Justin Hill" => "jhill.d@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/justindhill/DRPLoadingSpinner.git", :tag => s.version }

  s.default_subspec = 'core'
  s.subspec 'core' do |core|
    core.source_files = 'src/core/*.{h,m}'
  end

  s.subspec 'Texture' do |texture|
    texture.dependency 'Texture'
    texture.dependency 'DRPLoadingSpinner/core'
    texture.source_files = 'src/texture/*.{h,m}'
  end
end
