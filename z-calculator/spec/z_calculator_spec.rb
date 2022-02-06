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
end
# rubocop:enable Style/NestedParenthesizedCalls
