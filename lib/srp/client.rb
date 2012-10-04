require File.expand_path(File.dirname(__FILE__) + '/util')

module SRP
  class Client

    include Util

    attr_reader :salt, :verifier

    def initialize(username, password, salt = nil)
      @username = username
      @password = password
      @salt = salt || bigrand(4).hex
      @multiplier = multiplier # let's cache it
      calculate_verifier
    end

    def authenticate(server)
      a = bigrand(32).hex
      aa = modpow(GENERATOR, a) # A = g^a (mod N)
      bb = server.handshake(@username, aa)
      u = calculate_u(aa, bb)
      client_s = calculate_client_s(private_key, a, bb, u)
      server.validate(calculate_m(aa, bb, client_s))
    end

    protected

    def calculate_verifier
      @verifier ||= modpow(GENERATOR, private_key)
    end

    def private_key
      @private_key ||= calculate_private_key
    end

    def calculate_private_key
      shex = '%x' % [@salt]
      inner = sha256_str([@username, @password].join(':'))
      sha256_hex(shex, inner).hex
    end

    def calculate_client_s(x, a, bb, u)
      base = bb
      base += BIG_PRIME_N * @multiplier
      base -= modpow(GENERATOR, x) * @multiplier
      base = base % BIG_PRIME_N
      modpow(base, x * u + a)
    end
  end
end

