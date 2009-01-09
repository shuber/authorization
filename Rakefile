require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run the authorization tests'
task :default => :test

desc 'Test the authorization gem/plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the authorization gem/plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'authorization'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.markdown')
  rdoc.rdoc_files.include('lib/**/*.rb')
end