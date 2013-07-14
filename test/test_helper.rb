require "rubygems"
require 'test/unit'
require 'activesupport' # for HashWithIndifferentAccess
require File.expand_path(File.dirname(__FILE__) + '/../lib/ruby-srp.rb')

class Test::Unit::TestCase
  def fixture(filename)
    path = File.expand_path("../fixtures/#{filename}.json", __FILE__)
    HashWithIndifferentAccess[JSON.parse(File.read(path))]
  end
end

