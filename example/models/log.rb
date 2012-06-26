require 'yaml'

class Log

  def self.current
    @current ||= Log.new
  end

  def self.log(*args)
    self.current.log(*args)
  end

  def self.clear
    @current = nil
  end

  attr_accessor :actions

  def initialize
    @actions = []
  end

  def log(action, params)
    @actions << {action => params.dup}
  end

  def pretty
    @actions.to_yaml
  end

end
