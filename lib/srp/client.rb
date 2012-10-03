require File.expand_path(File.dirname(__FILE__) + '/util')

module SRP
  class Client

    include Util

    attr_reader :salt, :verifier

    def initialize(username, password, salt = nil)
      @username = username
      @password = password
      @salt = salt.hex || bigrand(4).hex
      @multiplier = multiplier # let's cache it
      calculate_verifier
    end

    def authenticate(server, username, password)
      x = calculate_x(username, password, salt)
      a = bigrand(32).hex
      aa = modpow(GENERATOR, a, PRIME_N) # A = g^a (mod N)
      bb = server.handshake(username, aa)
      u = calculate_u(aa, bb, PRIME_N)
      client_s = calculate_client_s(x, a, bb, u)
      server.validate(calculate_m(aa, bb, client_s))
    end

    protected
    def calculate_verifier
      x = calculate_x
      @verifier = modpow(GENERATOR, x, BIG_PRIME_N)
      @verifier
    end

    def calculate_x
      shex = '%x' % [@salt]
      inner = sha256_str([@username, @password].join(':'))
      sha256_str([shex].pack('H*') + [inner].pack('H*')).hex
    end

    def calculate_client_s(x, a, bb, u)
      base = bb
      base += PRIME_N * @multiplier
      base -= modpow(GENERATOR, x, PRIME_N) * @multiplier
      base = base % PRIME_N
      modpow(base, x * u + a, PRIME_N)
    end
  end
end

