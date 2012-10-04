require File.expand_path(File.dirname(__FILE__) + '/util')

module SRP
  class Session
    include Util
    attr_accessor :user, :aa, :bb

    def initialize(user, aa=nil)
      @user = user
      aa ? initialize_server(aa) : initialize_client
    end

    # client -> server: I, A = g^a
    def handshake(server)
      @bb = server.handshake(user.username, aa)
      @u = calculate_u
    end

    # client -> server: M = H(H(N) xor H(g), H(I), s, A, B, K)
    def validate(server)
      server.validate(calculate_m(client_secret))
    end

    def authenticate!(m)
      authenticate(m) || raise(SRP::WrongPassword)
    end

    def authenticate(m)
      if(m == calculate_m(server_secret))
        return m2
      end
    end

    protected

    def initialize_server(aa)
      @aa = aa
      @b = bigrand(32).hex
      # B = g^b + k v (mod N)
      @bb = (modpow(GENERATOR, @b) + multiplier * @user.verifier) % BIG_PRIME_N
      @u = calculate_u
    end

    def initialize_client
      @a = bigrand(32).hex
      @aa = modpow(GENERATOR, @a) # A = g^a (mod N)
    end

    # client: K = H( (B - kg^x) ^ (a + ux) )
    def client_secret
      base = @bb
      # base += BIG_PRIME_N * @multiplier
      base -= modpow(GENERATOR, @user.private_key) * multiplier
      base = base % BIG_PRIME_N
      modpow(base, @user.private_key * @u + @a)
    end

    # server: K = H( (Av^u) ^ b )
    # do not cache this - it's secret and someone might store the
    # session in a CookieStore
    def server_secret
      base = (modpow(@user.verifier, @u) * @aa) % BIG_PRIME_N
      modpow(base, @b)
    end

    def m1
      calculate_m(server_secret)
    end

    def m2
      sha256_int(@aa, m1, server_secret).hex
    end

    # this is outdated - SRP 6a uses
    # M = H(H(N) xor H(g), H(I), s, A, B, K)
    def calculate_m(s)
      sha256_int(@aa, @bb, s).hex
    end

    def calculate_u
      sha256_int(@aa, @bb).hex
    end
  end
end



