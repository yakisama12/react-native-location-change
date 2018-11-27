require "json"

json = File.read(File.join(__dir__, "package.json"))
package = JSON.parse(json).deep_symbolize_keys

Pod::Spec.new do |s|
  s.name = package[:name]
  s.version = package[:version]
  s.homepage = package[:homepage] 
  s.license = package[:license]
  s.authors = package[:author]
  s.summary = package[:description]
  s.source = { git: package[:repository][:url] }
  s.source_files  = 'ios/**/*.{h,m}'
  s.platform     = :ios, "9.0"
  s.dependency "React"
end
