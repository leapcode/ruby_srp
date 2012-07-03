class User

  def self.current
    @current
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
    self.salt = "5d3055e0acd3ddcfc15".hex
    # OpenSSL::Random.random_bytes(10).unpack("H*")[0]
    self.active = false
    User.current = self
  end

  def initialize_auth(params)
    self.srp = SRP::Server.new(self.salt, self.verifier)
    bb, u = self.srp.initialize_auth(params.delete('A').hex)
    return {:s => self.salt.to_s(16), :B => bb.to_s(16)}
  end

  def authenticate(params)
    if m2 = self.srp.authenticate(params.delete('M').hex)
      self.active = true
      return {:M => m2.to_s(16)}
    else
      self.active = false
      return {:error => "Access Denied"}
    end
  end

end
