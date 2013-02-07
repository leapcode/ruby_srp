require 'digest'
require 'openssl'

module SRP
  module Util
    require 'securerandom'

    # constants both sides know
    # in this case taken from srp-js
    PRIME_N = <<-EOS.split.join.hex
115b8b692e0e045692cf280b436735c77a5a9e8a9e7ed56c965f87db5b2a2ece3
    EOS

    BIG_PRIME_N = <<-EOS # 1024 bits modulus (N)
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

    def sha256_hex(h)
      Digest::SHA2.hexdigest([h].pack('H*'))
    end

    def sha256_str(s)
      Digest::SHA2.hexdigest(s)
    end

    def bigrand(bytes)
      SecureRandom.random_bytes(bytes).unpack("H*")[0]
    end

    def multiplier
      return "c46d46600d87fef149bd79b81119842f3c20241fda67d06ef412d8f6d9479c58".hex % PRIME_N
      @k ||= calculate_multiplier
    end

    protected

    def calculate_multiplier
      n = PRIME_N
      g = GENERATOR
      nhex = '%x' % [n]
      nlen = nhex.length + (nhex.length.odd? ? 1 : 0 )
      ghex = '%x' % [g]
      hashin = '0' * (nlen - nhex.length) + nhex \
        + '0' * (nlen - ghex.length) + ghex
      sha256_hex(hashin).hex % n
    end

    def calculate_m(aa, bb, s)
      hashin = '%x%x%x' % [aa, bb, s]
      sha256_str(hashin).hex
    end

    def calculate_u(aa, bb, n)
      nlen = 2 * ((('%x' % [n]).length * 4 + 7) >> 3)
      aahex = '%x' % [aa]
      bbhex = '%x' % [bb]
      return sha256_str("%x%x" % [aa, bb]).hex
    end
  end

end

