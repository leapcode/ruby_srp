require File.expand_path(File.dirname(__FILE__) + '/util')

module SRP
  class Client

    include Util

    attr_reader :salt, :verifier

    def initialize(username, password)
      @username = username
      @password = password
      @salt = bigrand(10).hex
      @multiplier = multiplier # let's cache it
      calculate_verifier
    end

    def authenticate(server, username, password)
      x = calculate_x(username, password, salt)
      a = bigrand(32).hex
      aa = modpow(GENERATOR, a, PRIME_N) # A = g^a (mod N)
      bb, u = server.initialize_auth(aa)
      client_s = calculate_client_s(x, a, bb, u)
      server.authenticate(aa, client_s)
    end

    protected
    def calculate_verifier
      x = calculate_x(@username, @password, @salt)
      @verifier = modpow(GENERATOR, x, PRIME_N)
    end

    def calculate_x(username, password, salt)
      shex = '%x' % [salt]
      spad = if shex.length.odd? then '0' else '' end
      sha1_hex(spad + shex + sha1_str([username, password].join(':'))).hex
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

