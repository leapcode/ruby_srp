class User

  def self.current
    # p "getting #{@current ? @current.login : 'nil'}"
    @current ||= User.new
  end

  def self.current=(user)
    @current = user
  end

  attr_accessor :login
  attr_accessor :salt
  attr_accessor :verifier
  attr_accessor :active
  attr_accessor :srp

  def initialize(login)
    self.login = login
    self.salt = OpenSSL::Random.random_bytes(10).unpack("H*")[0]
    self.active = false
    User.current = self
  end

  def initialize_auth(params)
    self.srp = SRP::Server.new(self.salt, self.verifier)
    bb, u = self.srp.initialize_auth(params.delete('A').to_i)
    return {:B => bb, :u => u}
  end

  def authenticate(params)
    if m2 = self.srp.authenticate(params.delete('aa').to_i, params.delete('M').to_i)
      self.active = true
      return {:M2 => m2}
    else
      self.active = false
      return {:error => "Access Denied"}
    end
  end

end
