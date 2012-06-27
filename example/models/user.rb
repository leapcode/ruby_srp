class User

  def self.current
    # p "getting #{@current ? @current.login : 'nil'}"
    @current ||= User.new
  end

  attr_accessor :login
  attr_accessor :salt
  attr_accessor :verifier
  attr_accessor :active
  attr_accessor :srp

  def signup!(params)
    self.login = params.delete('login')
    self.salt = params.delete('salt').to_i
    self.verifier = params.delete('verifier').to_i
    self.active = false
  end

  def initialize_auth(params)
    self.srp = SRP::Server.new(self.salt, self.verifier)
    bb, u = self.srp.initialize_auth(params.delete('A').to_i)
    return {:B => bb, :u => u}
  end

  def authenticate(params)
    if m2 = self.srp.authenticate(params.delete('aa').to_i, params.delete('M').to_i)
      return {:M2 => m2}
    else
      return {:error => "Access Denied"}
    end
  end


  def login!(params)
    self.active = valid_login?(params[:login], params[:password])
  end

  def valid_login?(login, password)
    (self.login == login) and (self.password == password)
  end
end
