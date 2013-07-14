module SRP
  class Session
    include SRP::Util
    attr_accessor :user

    # params:
    # user: user object that represents and account (username, salt, verifier)
    # aa: SRPs A ephemeral value. encoded as a hex string.
    def initialize(user, aa=nil)
      @user = user
      aa ? initialize_server(aa.hex) : initialize_client
    end

    # client -> server: I, A = g^a
    def handshake(server)
      @bb = server.handshake(user.username, aa)
    end

    # client -> server: M = H(H(N) xor H(g), H(I), s, A, B, K)
    def validate(server)
      server.validate(m)
    end

    def authenticate!(client_auth)
      authenticate(client_auth) || raise(SRP::WrongPassword)
    end

    def authenticate(client_auth)
      if(client_auth == m)
        @authenticated = true
        return @user
      end
    end

    def to_hash
      if @authenticated
        { :M2 => m2 }
      else
        { :B => bb.to_s(16),
#         :b => @b.to_s(16),    # only use for debugging
          :salt => @user.salt.to_s(16)
        }
      end
    end

    def to_json(options={})
      to_hash.to_json(options)
    end

    # for debugging use:
    def internal_state
      {
        username: @user.username,
        salt: @user.salt.to_s(16),
        verifier: @user.verifier.to_s(16),
        aa: aa.to_s(16),
        bb: bb.to_s(16),
        s: secret.to_s(16),
        k: k,
        m: m,
        m2: m2
      }
    end

    def aa
      @aa ||= modpow(GENERATOR, @a) # A = g^a (mod N)
    end

    # B = g^b + k v (mod N)
    def bb
      @bb ||= (modpow(GENERATOR, @b) + multiplier * @user.verifier) % BIG_PRIME_N
    end

    protected


    # only seed b for testing purposes.
    def initialize_server(aa, ephemeral = nil)
      @aa = aa
      @b = ephemeral || bigrand(32).hex
    end

    def initialize_client
      @a = bigrand(32).hex
      # bb will be set during handshake.
    end

    def secret
      return client_secret if @a
      return server_secret if @b
    end

    # client: K = H( (B - kg^x) ^ (a + ux) )
    def client_secret
      base = bb
      # base += BIG_PRIME_N * @multiplier
      base -= modpow(GENERATOR, @user.private_key) * multiplier
      base = base % BIG_PRIME_N
      modpow(base, @user.private_key * u + @a)
    end

    # server: K = H( (Av^u) ^ b )
    # do not cache this - it's secret and someone might store the
    # session in a CookieStore
    def server_secret
      base = (modpow(@user.verifier, u) * aa) % BIG_PRIME_N
      modpow(base, @b)
    end

    # SRP 6a uses
    # M = H(H(N) xor H(g), H(I), s, A, B, K)
    def m
      @m ||= sha256_hex(n_xor_g_long, login_hash, @user.salt.to_s(16), aa.to_s(16), bb.to_s(16), k)
    end

    def m2
      @m2 ||= sha256_hex(aa.to_s(16), m, k)
    end

    def k
      @k ||= sha256_int(secret)
    end

    def n_xor_g_long
      @n_xor_g_long ||= hn_xor_hg.bytes.map{|b| "%02x" % b.ord}.join
    end

    def login_hash
      @login_hash ||= sha256_str(@user.username)
    end

    def u
      @u ||= sha256_int(aa, bb).hex
    end

  end
end



