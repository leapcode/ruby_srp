require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class SessionTest < Test::Unit::TestCase

  attr_accessor :salt, :verifier, :username

  def setup
    @username = "testuser"
    @password = "password"
    @salt = '4c78c3f8'.hex
    @client = SRP::Client.new(@username, @password, @salt)
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
    assert_equal m2, session.authenticate(m)
  end


end
