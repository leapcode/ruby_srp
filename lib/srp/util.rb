require 'digest'
require 'openssl'

module SRP
  module Util

    # constants both sides know
    PRIME_N = <<-EOS.split.join.hex # 1024 bits modulus (N)
eeaf0ab9adb38dd69c33f80afa8fc5e86072618775ff3c0b9ea2314c9c25657
6d674df7496ea81d3383b4813d692c6e0e0d5d8e250b98be48e495c1d6089da
d15dc7d7b46154d6b6ce8ef4ad69b15d4982559b297bcf1885c529f566660e5
7ec68edbc3c05726cc02fd4cbf4976eaa9afd5138fe8376435b9fc61d2fc0eb
06e3
    EOS
    GENERATOR = 2 # g

    # a^n (mod m)
    def modpow(a, n, m)
      r = 1
      while true
        r = r * a % m if n[0] == 1
        n >>= 1
        return r if n == 0
        a = a * a % m
      end
    end

    def sha1_hex(h)
      Digest::SHA1.hexdigest([h].pack('H*'))
    end

    def sha1_str(s)
      Digest::SHA1.hexdigest(s)
    end

    def sha256_hex(h)
      Digest::SHA2.hexdigest([h].pack('H*'))
    end

    def sha256_str(s)
      Digest::SHA2.hexdigest(s)
    end

    def bigrand(bytes)
      OpenSSL::Random.random_bytes(bytes).unpack("H*")[0]
    end

    def multiplier
      n = PRIME_N
      g = GENERATOR
      nhex = '%x' % [n]
      nlen = nhex.length + (nhex.length.odd? ? 1 : 0 )
      ghex = '%x' % [g]
      hashin = '0' * (nlen - nhex.length) + nhex \
        + '0' * (nlen - ghex.length) + ghex
      sha1_hex(hashin).hex % n
    end
  end

end

