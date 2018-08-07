task default: %w[test diagram]

task :test do
  ruby "test/*.rb"
end

task :diagram do
  ruby "build/build_models.rb"
end

require 'rake/clean'

CLEAN.include FileList['out', 'gen']