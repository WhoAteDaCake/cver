require "spec"
require "../src/version"

VERSIONS = "1.0.10  1.0.11  1.0.12  1.0.13  1.0.4  1.0.5  1.0.6  1.0.7  1.0.8  1.0.9".split("  ")

describe Version do
  describe "#parse_tags" do
    it "can handle non standard versions" do
      with_broken = VERSIONS + ["test"]
      diff = Version.parse_tags(with_broken).map(&.to_s) - VERSIONS
      diff.size.should eq 0
    end

    it "parses versions correctly" do
      diff = Version.parse_tags(VERSIONS).map(&.to_s) - VERSIONS
      diff.size.should eq 0
    end

    it "sorts versions correctly" do
      parsed = Version.parse_tags(VERSIONS)
      parsed[0].to_s.should eq "1.0.13"
    end
  end
end