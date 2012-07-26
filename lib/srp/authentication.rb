require File.expand_path(File.dirname(__FILE__) + '/util')

module SRP
  module Authentication

    include Util


    def initialize_auth(aa)
      @aa = aa
      @b = bigrand(32).hex
      # B = g^b + k v (mod N)
      @bb = (modpow(GENERATOR, @b, PRIME_N) + multiplier * verifier) % PRIME_N
      return @bb
    end

    def authenticate(m)
      u = calculate_u(@aa, @bb, PRIME_N)
      base = (modpow(verifier, u, PRIME_N) * @aa) % PRIME_N
      server_s = modpow(base, @b, PRIME_N)
      if(m == calculate_m(@aa, @bb, server_s))
        return calculate_m(@aa, m, server_s)
      end
    end


  end

end


