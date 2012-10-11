module SRP
  class Session
    include SRP::Util
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
        @m2 = calculate_m2
        return @user
      end
    end

    def to_json(options={})
      if @m2
        { :M2 => @m2.to_s(16) }.to_json(options)
      else
        { :B => bb.to_s(16),
#          :b => @b.to_s(16),    # only use for debugging
          :salt => @user.salt.to_s(16)
        }.to_json(options)
      end
    end

    protected


    # only seed b for testing purposes.
    def initialize_server(aa, b = nil)
      @aa = aa
      @b =  b || bigrand(32).hex
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

    # this is outdated - SRP 6a uses
    # M = H(H(N) xor H(g), H(I), s, A, B, K)
    def calculate_m(secret)
      @k = sha256_int(secret).hex
      n_xor_g_long = hn_xor_hg.bytes.map{|b| "%02x" % b.ord}.join.hex
      username_hash = sha256_str(@user.username).hex
      @m = sha256_int(n_xor_g_long, username_hash, @user.salt, @aa, @bb, @k).hex
    end

    def calculate_m2
      sha256_int(@aa, @m, @k).hex
    end

    def calculate_u
      sha256_int(@aa, @bb).hex
    end

  end
end



