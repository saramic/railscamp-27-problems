require "z_calculator"

RSpec.describe ZCalculator do
  include described_class

  it "one" do
    expect(one).to eq(1)
  end

  it "plus one" do
    expect(plus(one).call).to eq(1)
  end

  it "adds one and one" do
    expect(one(plus(one))).to eq(2)
  end

  it "adds two and two" do
    expect(two(plus(two))).to eq(4)
  end
end
