require File.expand_path(File.dirname(__FILE__) + '/util')

module SRP
  class Client

    include Util

    attr_reader :salt, :verifier

    def initialize(username, password)
      @username = username
      @password = password
      @salt = "5d3055e0acd3ddcfc15".hex # bigrand(10).hex
      @multiplier = multiplier # let's cache it
      calculate_verifier
    end

    def authenticate(server, username, password)
      x = calculate_x(username, password, salt)
      a = bigrand(32).hex
      aa = modpow(GENERATOR, a, PRIME_N) # A = g^a (mod N)
      session = server.initialize_auth(aa)
      u = calculate_u(aa, session.bb, PRIME_N)
      client_s = calculate_client_s(x, a, session.bb, u)
      server.authenticate(calculate_m(aa,session.bb,client_s), session)
    end

    protected
    def calculate_verifier
      x = calculate_x(@username, @password, @salt)
      @verifier = modpow(GENERATOR, x, PRIME_N)
      @verifier
    end

    def calculate_x(username, password, salt)
      shex = '%x' % [salt]
      spad = "" # if shex.length.odd? then '0' else '' end
      sha256_str(spad + shex + sha256_str([username, password].join(':'))).hex
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

