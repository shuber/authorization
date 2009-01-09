Gem::Specification.new do |s| 
  s.name    = 'authorization'
  s.version = '1.0.0'
  s.date    = '2009-01-09'
  
  s.summary     = 'A rails gem/plugin that handles authorization'
  s.description = 'A rails gem/plugin that handles authorization'
  
  s.author   = 'Sean Huber'
  s.email    = 'shuber@huberry.com'
  s.homepage = 'http://github.com/shuber/authorization'
  
  s.has_rdoc = false
  s.rdoc_options = ['--line-numbers', '--inline-source', '--main', 'README.markdown']
  
  s.require_paths = ['lib']
  
  s.files = %w(
    CHANGELOG
    init.rb
    lib/authorization.rb
    MIT-LICENSE
    Rakefile
    README.markdown
    test/init.rb
  )
  
  s.test_files = %w(
    test/authorization_test.rb
  )
end