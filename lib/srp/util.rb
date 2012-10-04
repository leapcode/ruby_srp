require 'digest'
require 'openssl'

module SRP
  module Util

    # constants both sides know
    # in this case taken from srp-js
    PRIME_N = <<-EOS.split.join.hex
115b8b692e0e045692cf280b436735c77a5a9e8a9e7ed56c965f87db5b2a2ece3
    EOS

    BIG_PRIME_N = <<-EOS.split.join.hex # 1024 bits modulus (N)
eeaf0ab9adb38dd69c33f80afa8fc5e86072618775ff3c0b9ea2314c9c25657
6d674df7496ea81d3383b4813d692c6e0e0d5d8e250b98be48e495c1d6089da
d15dc7d7b46154d6b6ce8ef4ad69b15d4982559b297bcf1885c529f566660e5
7ec68edbc3c05726cc02fd4cbf4976eaa9afd5138fe8376435b9fc61d2fc0eb
06e3
    EOS
    GENERATOR = 2 # g

    # a^n (mod m)
    def modpow(a, n, m = BIG_PRIME_N)
      r = 1
      while true
        r = r * a % m if n[0] == 1
        n >>= 1
        return r if n == 0
        a = a * a % m
      end
    end

    #  Hashes the (long) int args
    def sha256_int(*args)
      sha256_hex(*args.map{|a| a.to_s(16)})
    end

    #  Hashes the hex args
    def sha256_hex(*args)
      h = args.join('')
      sha256_str([h].pack('H*'))
    end

    def sha256_str(s)
      Digest::SHA2.hexdigest(s)
    end

    def bigrand(bytes)
      OpenSSL::Random.random_bytes(bytes).unpack("H*")[0]
    end

    def multiplier
      @k ||= calculate_multiplier
    end

    protected

    def calculate_multiplier
      # GENERATOR hex needs to be prefixed with 0 so it's not "2" -> 32
      ghex = '0%x' % GENERATOR
      sha256_hex(BIG_PRIME_N.to_s(16), ghex).hex
    end

  end

end

