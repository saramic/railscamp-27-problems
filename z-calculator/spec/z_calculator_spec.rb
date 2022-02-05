require "z_calculator"

RSpec.describe ZCalculator do
  include described_class
  it "adds 2 number" do
    expect(one(plus(one))).to eq(2)
  end
end
