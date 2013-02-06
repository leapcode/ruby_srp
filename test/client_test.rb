require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class ClientTest < Test::Unit::TestCase

  def setup
    @login = "testuser"
    @password = "password"
  end

  def test_calculation_of_private_key
    @client = SRP::Client.new @login,
      :password => @password,
      :salt => "7686acb8".hex
    assert_equal "84d6bb567ddf584b1d8c8728289644d45dbfbb02deedd05c0f64db96740f0398",
      "%x" % @client.send(:private_key)
  end

  # using python srp:
  # s,V = pysrp.create_salted_verification_key("testuser", "password", pysrp.SHA256, pysrp.NG_1024)

  def test_verifier
    @client = SRP::Client.new @login,
      :password => @password,
      :salt => '4c78c3f8'.hex
    v = '474c26aa42d11f20544a00f7bf9711c4b5cf7aab95ed448df82b95521b96668e7480b16efce81c861870302560ddf6604c67df54f1d04b99d5bb9d0f02c6051ada5dc9d594f0d4314e12f876cfca3dcd99fc9c98c2e6a5e04298b11061fb8549a22cde0564e91514080df79bca1c38c682214d65d590f66b3719f954b078b83c'
    assert_equal v, "%x" % @client.verifier
  end
end



