require File.expand_path(File.dirname(__FILE__) + '/util')

module SRP
  module Authentication

    include Util

    class Session
      include Util
      attr_accessor :aa, :bb

      def initialize(aa, verifier)
        @aa = aa
        @b = bigrand(32).hex
        # B = g^b + k v (mod N)
        @bb = (modpow(GENERATOR, @b, BIG_PRIME_N) + multiplier * verifier) % BIG_PRIME_N
      end

      def u
        calculate_u(aa, bb)
      end

      # do not cache this - it's secret and someone might store the
      # session in a CookieStore
      def secret(verifier)
        base = (modpow(verifier, u, BIG_PRIME_N) * aa) % BIG_PRIME_N
        modpow(base, @b, BIG_PRIME_N)
      end

      def m1(verifier)
        calculate_m(aa, bb, secret(verifier))
      end

      def m2(m1, verifier)
        calculate_m(aa, m1, secret(verifier))
      end

    end

    def initialize_auth(aa)
      return Session.new(aa, verifier)
    end

    def authenticate!(m, session)
      authenticate(m, session) || raise(SRP::WrongPassword)
    end

    def authenticate(m, session)
      if(m == session.m1(verifier))
        return session.m2(m, verifier)
      end
    end


  end

end


