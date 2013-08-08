## Ruby-SRP

Secure remote password for ruby.

*IMPORTANT:* This is still in early development. Versions prior to 0.2.1 are known to be insecure due to not validating the ephemeral public keys send.

So far this library supports the two way authentication provided by SRP. It does not offer encryption for the traffic with the calculated shared secret yet. It should not be hard to add - but we do not need it yet.

[![Build Status](https://secure.travis-ci.org/leapcode/ruby_srp.png?branch=master)](http://travis-ci.org/leapcode/ruby_srp) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/leapcode/ruby_srp)
