require File.expand_path(File.dirname(__FILE__) + '/test_helper')
require 'json'

class SessionTest < Test::Unit::TestCase

  Struct.new("Client", :username, :salt, :verifier)

  def test_client_public_key_validation
    aa = SRP::Util::BIG_PRIME_N.to_s(16)
    client = {} # stub
    assert_raises SRP::InvalidEphemeral do
      session = SRP::Session.new(client, aa)
    end
  end

  def test_equivalance_to_py_srp
    data = fixture(:py_srp)
    client = stub_client(data)
    session = init_session(client, data)

    assert_same_values(data, session.internal_state)
    assert_equal client, session.authenticate(data[:m])
    assert_equal({:M2 => data[:m2]}, session.to_hash)
    assert_equal({'M2' => data[:m2]}.to_json, session.to_json)
  end

  def test_zero_padded_salt
    data = fixture(:zero_padded_salt)
    client = stub_client(data)
    session = init_session(client, data)
    state = session.internal_state
    # Zero padding of the salt would cause next assertion to fail.
    # But we are only interested in the calculated results anyway.
    state.delete(:salt)

    assert_same_values(data, state)
    assert_equal client, session.authenticate(data[:m])
  end

  def test_failing_js_login
    data = fixture(:failed_js_login)
    client = stub_client(data)
    session = init_session(client, data)

    assert_same_values(data, session.internal_state)
    assert_equal client, session.authenticate(data[:m])
  end

  def stub_client(data)
    @username = data[:username]
    @password = data[:password]
    @salt = data[:salt].hex
    @client = SRP::Client.new @username,
      :password => @password,
      :salt => @salt
    @verifier = @client.verifier
    Struct::Client.new @username, @salt, @verifier
  end

  def init_session(client, data)
    aa = data[:aa]
    b  = data[:b].hex
    session = SRP::Session.new(client, aa)
    # seed b to compare to py_srp
    session.send(:initialize_server, aa, b)
    session
  end

  # check all values in a hash against expectations.
  #
  # Note this will NOT assert all expected keys are set.
  # So an empty Hash will always pass.
  def assert_same_values(expected, actual)
    actual.each_pair do |k,v|
      next unless expected[k]
      assert_equal expected[k], v, "Values for #{k} are not matching"
    end
  end

end
