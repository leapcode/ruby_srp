# Ruby library for the server side of the Secure Remote Password protocol

# References
# `The Stanford SRP Homepage',
# http://srp.stanford.edu/
# `SRP JavaScript Demo',
# http://srp.stanford.edu/demo/demo.html

$:.unshift File.dirname(__FILE__)
module SRP
  autoload :Client, 'srp/client'
  autoload :Server, 'srp/server'
end
