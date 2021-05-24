require "spec"
require "../src/version"

VERSIONS = "1.0.10  1.0.11  1.0.12  1.0.13  1.0.4  1.0.5  1.0.6  1.0.7  1.0.8  1.0.9".split("  ")

describe Version do
  describe "#of_s" do
    it "parses versions correctly" do
      VERSIONS.map { |v| Version.of_s v }.map(&.to_s).should eq VERSIONS
    end

    it "sorts versions correctly" do
      parsed = VERSIONS.map { |v| Version.of_s v }
      sorted = parsed.sort
      sorted[sorted.size - 1].to_s.should eq "1.0.13"
    end
  end
end