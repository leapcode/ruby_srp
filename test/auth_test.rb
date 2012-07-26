require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class User

  include SRP::Authentication

  attr_accessor :salt, :verifier

  def initialize(salt, verifier)
    @salt = salt
    @verifier = verifier
  end
end

class AuthTest < Test::Unit::TestCase

  def setup
    @username = 'user'
    @password = 'opensesami'
    @client = SRP::Client.new(@username, @password)
    @server = User.new(@client.salt, @client.verifier)
  end

  def test_successful_auth
    assert @client.authenticate(@server, @username, @password)
  end

  def test_wrong_password
    assert !@client.authenticate(@server, @username, "wrong password")
  end

  def test_wrong_username
    assert !@client.authenticate(@server, "wrong username", @password)
  end
end


