#!/usr/bin/env ruby

$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "lib")
require "z_calculator"

class ExecuteMath
  include ZCalculator

  def evaluate(expression)
    eval(expression) # rubocop:disable Security/Eval
  end
end

pp ExecuteMath.new.evaluate(ARGV.join(" "))
