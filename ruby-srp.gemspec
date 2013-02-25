Gem::Specification.new do |s|
  s.name              = "ruby-srp"
  s.version           = "0.1.6"
  s.platform          = Gem::Platform::RUBY
  s.authors           = ["Azul"]
  s.email             = ["azul@leap.se"]
  s.homepage          = "http://github.com/leapdev/ruby.srp"
  s.summary           = "Secure remote password library for ruby"
  s.description       = "SRP client and server based on version 6 of the standard"
 
  s.required_rubygems_version = ">= 1.3.6"
 
  # If you have runtime dependencies, add them here
  # s.add_runtime_dependency "other", "~> 1.2"
 
  # If you have development dependencies, add them here
  # s.add_development_dependency "another", "= 0.9"
 
  # The list of files to be contained in the gem 
  s.files         = `git ls-files`.split("\n")
  # s.executables   = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  # s.extensions    = `git ls-files ext/extconf.rb`.split("\n")
 
  s.require_path = 'lib'
 
end
