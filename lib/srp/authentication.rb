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
        @bb = (modpow(GENERATOR, @b, PRIME_N) + multiplier * verifier) % PRIME_N
        @verifier = verifier
      end

      def u
        calculate_u(aa, bb, PRIME_N)
      end

      def secret
        @s ||= calculate_secret
      end

      def m1
        calculate_m(aa, bb, secret)
      end

      def m2
        calculate_m(aa, m1, secret)
      end

      protected

      def calculate_secret
        base = (modpow(@verifier, u, PRIME_N) * aa) % PRIME_N
        modpow(base, @b, PRIME_N)
      end
    end

    def initialize_auth(aa)
      return Session.new(aa, verifier)
    end

    def authenticate(m, session)
      if(m == session.m1)
        return session.m2
      end
    end


  end

end


