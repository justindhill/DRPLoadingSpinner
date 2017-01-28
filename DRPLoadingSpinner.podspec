
Pod::Spec.new do |s|

  s.name         = "DRPLoadingSpinner"
  s.version      = "1.0.2"
  s.summary      = "A loading spinner and refresh control that's strikingly Material-like."

  s.description  = <<-DESC
	"A loading spinner and refresh control that's strikingly Material-like."
  DESC

  s.homepage     = "https://github.com/justindhill/DRPLoadingSpinner"
  s.screenshots  = ["https://camo.githubusercontent.com/de77faf4dea83039e9038cfe80b907602b52961d/687474703a2f2f696d6775722e636f6d2f635562654974462e676966", "https://camo.githubusercontent.com/56ea4e538c729d93e4fbd51e610ce4b9ff746284/687474703a2f2f696d6775722e636f6d2f575163677164662e676966"]

  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author       = { "Justin Hill" => "jhill.d@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/justindhill/DRPLoadingSpinner.git", :tag => s.version }
  s.source_files = "src", "src/*.{h,m}"

end
