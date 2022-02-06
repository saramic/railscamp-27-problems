require "z_calculator"

# rubocop:disable Style/NestedParenthesizedCalls
RSpec.describe ZCalculator do
  include ZCalculator

  # NOTE: Michael likes this
  describe "math" do
    subject(:expression) { eval self.class.description } # rubocop:disable Security/Eval

    describe "one plus one" do
      it { is_expected.to eq 2 }
    end
  end

  # NOTE: Luca likes this
  it "adds numbers" do
    expect(one plus one).to eq 2
    expect(one_hundred plus nine).to eq 109
    expect(one plus two plus three plus four plus five).to eq 15
  end

  it "multiplies numbers" do
    expect(one times one).to eq 1
    expect(one_hundred times nine).to eq 900
    expect(one times two times three times four times five).to eq 120
  end

  it "subract 2 numbers" do
    expect(one minus one).to eq 0
    expect(one_hundred minus nine).to eq 91
    expect(one minus two).to eq(-1)
  end

  it "divide 2 numbers" do
    expect(one divided by one).to eq 1
    expect(one_hundred divided by ten).to eq 10
  end

  it "divides 2 numbers and floors result to closest integer" do
    expect(one_hundred divided by nine).to eq 11 # 11.111
    expect(one_hundred divided by fifteen).to eq 6 # 6.667
    expect(one divided by two).to eq 0 # 0.5
  end

  describe "left-associative operations on many numbers" do
    it "subtract multiple numbers" do
      pending "left associative operations like minus and divide by for multiple numbers is NOT supported"
      expect(zero plus one minus one minus one).to eq(-2)
    end

    it "divide multiple numbers" do
      pending "left associative operations like minus and divide by for multiple numbers is NOT supported"
      expect(twelve divided by two divided by three).to eq(2)
    end
  end
end
# rubocop:enable Style/NestedParenthesizedCalls
