module SRP
  class Client

    include SRP::Util

    attr_reader :salt, :verifier, :username

    def initialize(username, options)
      @username = username
      if options[:password]
        @password = options[:password]
        @salt = options[:salt] || bigrand(4).hex
        calculate_verifier
      else
        @verifier = options[:verifier]
        @salt = options[:salt]
      end
    end

    def authenticate(server)
      @session = SRP::Session.new(self)
      @session.handshake(server)
      @session.validate(server)
    end

    def private_key
      @private_key ||= calculate_private_key
    end

    protected

    def calculate_verifier
      @verifier ||= modpow(GENERATOR, private_key)
    end

    def calculate_private_key
      shex = '%x' % [@salt]
      inner = sha256_str([@username, @password].join(':'))
      sha256_hex(shex, inner).hex
    end

  end
end

