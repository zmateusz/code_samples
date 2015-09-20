$LOAD_PATH << '.'

require 'computer'
require 'hardware'

class Laptop < Computer
  include Hardware

  attr_reader :cpu
  attr_writer :name
  attr_accessor :ram

  def initialize(name, cpu, ram = 1024)
    super()
    @name = name
    @cpu = cpu
    @ram = ram
  end

  def info
    super
    puts @name
    puts "#{@cpu}GHz, #{@ram/1024}GB RAM"
    puts "#{@hdd}GB"
  end

end

l = Laptop.new("HP Pro", 3, 8192)

l.info
puts
puts l.score
puts
l.price
puts "----------"
Hardware::status
puts Hardware::VER

# custom printing method
# define get, set methods

# useful methods: .class, .methods, .object_id, .inspect
# .instance_variables, .instance_variable_get(:@name)

# find `pwd` -name *.rb
# irb -I load_path
