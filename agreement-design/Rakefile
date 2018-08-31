task default: %w[test build]

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*.rb']
  t.verbose = true
end

task :build do
  ruby "generate.rb"
end

task :deploy do
   `gem build agreement-design.gemspec`
   `gem push *.gem`
end

require 'rake/clean'

CLEAN.include FileList['out', 'gen', '*.gem']
