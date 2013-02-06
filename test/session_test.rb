require File.expand_path(File.dirname(__FILE__) + '/test_helper')
require 'json'

class SessionTest < Test::Unit::TestCase

  attr_accessor :salt, :verifier, :username

  def setup
    @username = "testuser"
    @password = "password"
    @salt = '4c78c3f8'.hex
    @client = SRP::Client.new @username,
      :password => @password,
      :salt => @salt
    @verifier = @client.verifier
  end

  def test_equivalance_to_py_srp
    aa = '9ff9d176b37d9100ad4d788b94ef887df6c88786f5fa2419c9a964001e1c1fa5cd22ea39dcf27682dac6cd8861d9de88184653451fd47f5654845ed24e828d531f95c44377c9bc3f5dd83a669716257c7b975a3a032d4d8adb605553cf4d45c483d7aceb7e6a23c5bd4b0aeeb2ef138b7fc75b27d9d706851c3ab9c721710272'.hex
    b = 'ce414b3b52d13a1f67416b7e00cdefb07c874291aed395efeab9435ec1ad6ac3'.hex
    bb = 'b2e852fe7af02d7931186f4958844b829d2976dd58c7bc7928ba3102ff269a9029c707112ab0b7cafdaf86a760f7b50ddd9c847e0c97f564d53cfd52daf61982f06582d49bbb3ea4ad6be55d513028eaf400a6d5a9d26b47689d3438a552716d65680d1b6ee77df3c9b3b6ba61023985562f2be4a6f1723282a2013160594565'.hex
    m = 'a0c066844117ffe7a7999f84356f3a7c8dce38e4e936eca2b6979ab0fce6ff6d'.hex
    m2 = '1f4a5ba9c5280b5b752465670f351bb1e61ff9ca06e02ad43c4418affeb3a1ef'.hex
    session = SRP::Session.new(self, aa)
    session.send(:initialize_server, aa, b) # seeding b to compare to py_srp
    assert_equal bb.to_s(16), session.bb.to_s(16)
    assert_equal self, session.authenticate(m)
    assert_equal({'M2' => m2.to_s(16)}.to_json, session.to_json)
  end

  def test_zero_padded_salt
    @username = "RLNFB7"
    password = "NRH9NRT958BO"
    @salt = "0401b02e".hex
    @verifier = "943c7bf983b9afd0e08ba7d9c9da68cbf8bc88f05d564f002bd669130bb66ceb2b5aafa5c4a9cac09f42a17f7079b67a964365022283cc249446a165ca9e02855d188ca193bf0b4703d0d83254623e3e91576ba1f3b353981836226f3e9c36b7592a6a0daa608018273e7d3a3cb8615eee3606af9eec4a83e1947c8717f9415e".hex
    aa = "ea40a95b4ccf1934767e9098f0f5639f5b83321eb77137f3c7b50bb90323651ebbe14b08956e471d4b96ae12c96814fbc56bfe408afd4cffca17d53dc30653a2e9e0e57f5b97e8736a5a90470708a32f63e6417651303e331d6c3bf3d229379dd746fb9f47220ee52b6da008ce88710de27c058841d56644d58e98e1c8795371".hex
    b = "78e12fc099be1409e0fce3bf84484d89d58710bcc3d8a0e05227fb291be3fb28".hex
    bb = "d8d50a862b7e8a897f8b0554c4a474e8aa152bd08f23436773fbb977e81cbf5e8262937ffb7ad6b72e3aa7f72deec947cdb286ab466e490d7c544bf443331ad12657c8f9bb2aabf508b73ea1ed29d03a060f5f2a70baef858bdb79c5c878844c058fe10c2cc746b0fb701e98d8d6405ab7d0b65bb4f87cf8e47b25ae4ee6e53b".hex
    m = "d5cbec7254ce66f421ceddbfe8a0a8991b5be2aa9c25d868f073f4459dfc358b".hex
    client = SRP::Client.new @username,
      :password => password,
      :salt => @salt
    assert_equal @verifier.to_s(16), client.verifier.to_s(16)
    session = SRP::Session.new(self, aa)
    session.send(:initialize_server, aa, b) # seeding b to compare to py_srp
    assert_equal bb.to_s(16), session.bb.to_s(16)
    assert session.authenticate(m)
  end
end
