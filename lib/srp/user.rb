#
# SRP User on the server.
#
# This will be used in the session instead of the real user record so the
# session does not get cluttered with the whole user record.
#
module SRP
  class User

    attr_reader :username, :salt, :verifier

    def initialize(user)
      @username = user.username
      @salt = user.salt
      @verifier = user.verifier
    end

  end
end
