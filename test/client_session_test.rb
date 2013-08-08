require File.expand_path(File.dirname(__FILE__) + '/test_helper')
require 'json'

class ClientSessionTest < Test::Unit::TestCase

  class UserStub
    def username; end
  end

  class ServerStub
    def initialize(bb)
      @bb = bb
    end

    def handshake(username, aa)
      @bb
    end
  end

  def test_retrieval_of_bb
    bb = SRP::Util::BIG_PRIME_N + 1
    bb = bb.to_s(16)
    user = UserStub.new
    server = ServerStub.new(bb)
    session = SRP::Session.new(user)
    session.handshake(server)
    assert_equal bb, session.instance_variable_get("@bb")
  end

  def test_validation_of_bb
    user = UserStub.new
    server = ServerStub.new(SRP::Util::BIG_PRIME_N.to_s(16))
    assert_raises SRP::InvalidEphemeral do
      session = SRP::Session.new(user)
      session.handshake(server)
    end
  end

  def test_calculation_of_aa
    data = fixture(:failed_js_client)
    user = {} # stub
    session = SRP::Session.new(user)
    session.instance_variable_set("@a", data[:a].hex)
    assert_equal data[:aa], session.aa
  end

end
