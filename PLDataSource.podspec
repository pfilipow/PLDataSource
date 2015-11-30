
Pod::Spec.new do |s|
  s.name             = "PLDataSource"
  s.version          = "0.9.0"
  s.summary          = "Table view data source classes to make presentation of non-trivial tables easier."

  s.description      = <<-DESC
PLDataSource is a collection of classes that make it easier to build a non-trivial data source for a UITableView. The original motivation was to list different Core Data entities in one table easily, using NSFetchedResultsController. But the structure can be extended to many other use-cases.
                       DESC

  s.homepage         = "https://github.com/PendarLabs/PLDataSource"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Hirad Motamed" => "hirad@pendarlabs.com" }
  s.source           = { :git => "https://github.com/PendarLabs/PLDataSource.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/thehirad'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'PLDataSource' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
