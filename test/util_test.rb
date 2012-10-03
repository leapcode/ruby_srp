require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class UtilTest < Test::Unit::TestCase

  include SRP::Util

  # comparing to the hash created with python srp lib to make sure
  # we use the same constants and hash the same way.
  def test_sha256_of_prime
    n = BIG_PRIME_N
    nhex = '%x' % [n]
    assert_equal "494b6a801b379f37c9ee25d5db7cd70ffcfe53d01b7c9e4470eaca46bda24b39",
      sha256_hex(nhex)
  end

  def test_hashing
    x = sha256_str("testuser:password")
    assert_equal 'a5376a27a385bcd791d76cbd6484e1bde130129210e4647a4583e49f45de107f',
      x
  end

  def test_packing_hex_to_byte_string
    shex = "7686acb8"
    assert_equal [118, 134, 172, 184].pack('C*'), [shex].pack('H*')
  end

  def test_multiplier
    # >>> "%x" % pysrp.H(sha, N, g)
    assert_equal 'bf66c44a428916cad64aa7c679f3fd897ad4c375e9bbb4cbf2f5de241d618ef0',
      "%x" % multiplier
  end

end
