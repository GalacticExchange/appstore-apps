class Checker

  attr_accessor :res

  def initialize args
    @res = {}
    args.each{|arg| @res[arg] = 'not started' }
  end

  def check
    checked = true
    @res.each {|arg| checked = false if !arg[1] }
    puts_ln ""
    puts "Result: #{@res.inspect}"
    checked
  end

end