require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class User

  include SRP::Authentication

  attr_accessor :salt, :verifier

  def initialize(salt, verifier)
    @salt = salt
    @verifier = verifier
  end

  def handshake(login, aa)
    @session = initialize_auth(aa)
    return @session.bb
  end

  def validate(m)
    authenticate(m, @session)
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
    assert @client.authenticate(@server)
  end

  def test_a_wrong_password
    client = SRP::Client.new(@username, "wrong password", @client.salt)
    assert !client.authenticate(@server)
  end

  def test_wrong_username
    client = SRP::Client.new("wrong username", @password, @client.salt)
    assert !client.authenticate(@server)
  end
end


