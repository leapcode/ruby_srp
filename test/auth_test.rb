require File.expand_path(File.dirname(__FILE__) + '/test_helper')

# single user test server.
# You obviously want sth. different for real life.
class Server

  attr_accessor :salt, :verifier, :username

  def initialize(salt, verifier, username)
    @salt = salt
    @verifier = verifier
    @username = username
  end

  def handshake(login, aa)
    # this can be serialized and needs to be persisted between requests
    @session = SRP::Session.new(self, aa)
    return @session.bb
  end

  def validate(m)
    @session.authenticate(m)
  end

end

class AuthTest < Test::Unit::TestCase

  def setup
    @username = 'user'
    @password = 'opensesami'
    @client = SRP::Client.new(@username, @password)
    @server = Server.new(@client.salt, @client.verifier, @username)
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


