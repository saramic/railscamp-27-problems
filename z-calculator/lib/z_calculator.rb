require "pry"
require "numbers_in_words"

module ZCalculator
  def respond_to_missing?
    true
  end

  def method_missing(method, *args)
    num = NumbersInWords.in_numbers(method.to_s)

    return num unless args.any?
    args.first.call(num)
  end

  def plus(coerced_number)
    ->(number = 0) { number.public_send(:+, coerced_number) }
  end

  # left associative
  def minus(coerced_number)
    ->(number = 0) { number.public_send(:-, coerced_number) }
  end

  def times(coerced_number)
    ->(number = 0) { number.public_send(:*, coerced_number) }
  end

  # left associative
  def divide(coerced_number)
    ->(number = 0) { number.public_send(:/, coerced_number) }
  end

  def by(args)
    args
  end
end
