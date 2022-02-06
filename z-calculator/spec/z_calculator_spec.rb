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
end
# rubocop:enable Style/NestedParenthesizedCalls
