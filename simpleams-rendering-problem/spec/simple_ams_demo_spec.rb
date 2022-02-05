# frozen_string_literal: true

require "simple_ams"
require "ostruct"

class TestRelationSerializer
  include SimpleAMS::DSL
  attributes :rel_key
end

class TestSerializer
  include SimpleAMS::DSL
  attributes :key
  has_one :relation, serializer: TestRelationSerializer
end

ResourceStruct = Struct.new(:key, :relation, keyword_init: true)
RelationStruct = Struct.new(:rel_key, keyword_init: true)

RSpec.describe "SimpleAMS resource render demo" do # rubocop:disable RSpec/DescribeClass
  subject(:as_json) { adapter.as_json }

  let(:adapter) {
    SimpleAMS::Adapters::AMS.new(
      SimpleAMS::Document.new(
        SimpleAMS::Options.new(
          resource,
          injected_options: {serializer: TestSerializer}
        )
      ),
      {}
    )
  }

  context "when resource is a double" do
    let(:resource) do
      instance_double(
        "resource double",
        key: "value",
        relation: instance_double(
          "reation1",
          rel_key: "relation value"
        )
      )
    end

    it "renders key and relation" do
      expect(as_json).to eq(
        {
          key: "value",
          relation: {
            rel_key: "relation value"
          }
        }
      )
    end
  end

  context "when resource is an OpenStruct" do
    let(:resource) do
      # rubocop:disable Style/OpenStructUse
      OpenStruct.new(
        key: "value",
        relation: OpenStruct.new(
          rel_key: "relation value"
        )
      )
      # rubocop:enable Style/OpenStructUse
    end

    it "renders key and relation" do
      expect(as_json).to eq(
        {
          key: "value",
          relation: {
            rel_key: "relation value"
          }
        }
      )
    end
  end

  context "when resource is a Struct" do
    let(:resource) do
      ResourceStruct.new(
        key: "value",
        # DOES NOT WORK as Stuct.respond_to?(:each) making this an AMS Folder not Document
        relation: RelationStruct.new(
          rel_key: "relation value"
        )
      )
    end

    it "renders key and relation" do
      pending "working out what is different from OpenStruct"
      # undefined method `rel_key' for "relation value":String
      expect(as_json).to eq(
        {
          key: "value",
          relation: {
            rel_key: "relation value"
          }
        }
      )
    end
  end
end
