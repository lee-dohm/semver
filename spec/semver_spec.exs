defmodule SemverSpec do
  use ESpec

  describe "is_valid" do
    it "accepts a standard version number", do: expect(Semver.is_valid("1.1.1")).to eq(true)
    it "accepts a version with leading v", do: expect(Semver.is_valid("v1.1.1")).to eq(true)

    it "does not accept other leading characters" do
      expect(Semver.is_valid("z1.1.1")).to eq(false)
    end

    it "does not accept random trailing characters" do
      expect(Semver.is_valid("1.1.1vvv")).to eq(false)
    end

    it "accepts multi-digit segments", do: expect(Semver.is_valid("11.11.11")).to eq(true)
    it "accepts all zeros", do: expect(Semver.is_valid("0.0.0")).to eq(true)
    it "does not accept leading zeros", do: expect(Semver.is_valid("01.01.01")).to eq(false)
    it "accepts pre-release versions", do: expect(Semver.is_valid("1.1.1-alpha")).to eq(true)

    it "accepts dotted pre-release versions" do
      expect(Semver.is_valid("1.1.1-alpha.beta")).to eq(true)
    end

    it "accepts build versions", do: expect(Semver.is_valid("1.1.1+alpha")).to eq(true)
    it "accepts dotted build versions" do
      expect(Semver.is_valid("1.1.1+alpha.beta")).to eq(true)
    end

    it "accepts both pre-release and build versions" do
      expect(Semver.is_valid("1.1.1-alpha.beta+12345.67890")).to eq(true)
    end
  end
end
