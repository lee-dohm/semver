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

  describe "parse" do
    it "rejects an invalid version", do: expect(Semver.parse("vvv")).to eq({:error, :invalid})

    describe "a normal version" do
      before do
        {:ok, ver} = Semver.parse("1.2.3")
        {:ok, ver: ver}
      end

      it "parses the major version", do: __.ver.major |> should eq 1
      it "parses the minor version", do: __.ver.minor |> should eq 2
      it "parses the patch version", do: __.ver.patch |> should eq 3
      it "gives an empty list for prerelease", do: __.ver.prerelease |> should eq []
      it "gives an empty list for build", do: __.ver.build |> should eq []
    end

    describe "a version including prerelease components" do
      before do
        {:ok, ver} = Semver.parse("1.2.3-alpha.beta")
        {:ok, ver: ver}
      end

      it "parses the major version", do: __.ver.major |> should eq 1
      it "parses the minor version", do: __.ver.minor |> should eq 2
      it "parses the patch version", do: __.ver.patch |> should eq 3
      it "gives an empty list for prerelease", do: __.ver.prerelease |> should eq ["alpha", "beta"]
      it "gives an empty list for build", do: __.ver.build |> should eq []
    end

    describe "a version including build components" do
      before do
        {:ok, ver} = Semver.parse("1.2.3+alpha.beta")
        {:ok, ver: ver}
      end

      it "parses the major version", do: __.ver.major |> should eq 1
      it "parses the minor version", do: __.ver.minor |> should eq 2
      it "parses the patch version", do: __.ver.patch |> should eq 3
      it "gives an empty list for prerelease", do: __.ver.prerelease |> should eq []
      it "gives an empty list for build", do: __.ver.build |> should eq ["alpha", "beta"]
    end
  end
end
