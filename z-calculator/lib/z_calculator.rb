require "pry"
require "numbers_in_words"

module ZCalculator
  def respond_to_missing?
    true
  end

  def method_missing(method, *args)
    num = NumbersInWords.in_numbers(method.to_s)

    return num unless args.any?
    num.public_send(*args.first)
  end

  def plus(coeerced_number)
    ["+", coeerced_number]
  end
end
