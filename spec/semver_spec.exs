defmodule SemverSpec do
  use ESpec

  describe "version" do
    it "matches the expected version", do: expect(Semver.version).to eq(File.read!("VERSION") |> String.strip)
  end

  describe "increment" do
    describe "version structures" do
      let :version, do: %Semver{major: 1, minor: 2, patch: 3}

      it "increments the patch version" do
        expect(Semver.increment(version, :patch)).to eq(%Semver{major: 1, minor: 2, patch: 4})
      end

      it "increments the minor version" do
        expect(Semver.increment(version, :minor)).to eq(%Semver{major: 1, minor: 3, patch: 0})
      end

      it "increments the major version" do
        expect(Semver.increment(version, :major)).to eq(%Semver{major: 2, minor: 0, patch: 0})
      end

      describe "with prerelease components" do
        let :version, do: %Semver{major: 1, minor: 2, patch: 3, prerelease: ["alpha"]}

        it "wipes the prerelease on patch increment" do
          expect(Semver.increment(version, :patch)).to eq(%Semver{major: 1, minor: 2, patch: 4})
        end

        it "wipes the prerelease on minor increment" do
          expect(Semver.increment(version, :minor)).to eq(%Semver{major: 1, minor: 3, patch: 0})
        end

        it "wipes the prerelease on major increment" do
          expect(Semver.increment(version, :major)).to eq(%Semver{major: 2, minor: 0, patch: 0})
        end
      end

      describe "with build components" do
        let :version, do: %Semver{major: 1, minor: 2, patch: 3, build: ["alpha"]}

        it "wipes the build on patch increment" do
          expect(Semver.increment(version, :patch)).to eq(%Semver{major: 1, minor: 2, patch: 4})
        end

        it "wipes the build on minor increment" do
          expect(Semver.increment(version, :minor)).to eq(%Semver{major: 1, minor: 3, patch: 0})
        end

        it "wipes the build on major increment" do
          expect(Semver.increment(version, :major)).to eq(%Semver{major: 2, minor: 0, patch: 0})
        end
      end
    end

    describe "version strings" do
      let :version, do: "1.2.3"

      it "increments the patch version" do
        expect(Semver.increment(version, :patch)).to eq("1.2.4")
      end

      it "increments the minor version" do
        expect(Semver.increment(version, :minor)).to eq("1.3.0")
      end

      it "increments the major version" do
        expect(Semver.increment(version, :major)).to eq("2.0.0")
      end

      describe "with prerelease components" do
        let :version, do: "1.2.3-alpha"

        it "wipes the prerelease on patch increment" do
          expect(Semver.increment(version, :patch)).to eq("1.2.4")
        end

        it "wipes the prerelease on minor increment" do
          expect(Semver.increment(version, :minor)).to eq("1.3.0")
        end

        it "wipes the prerelease on major increment" do
          expect(Semver.increment(version, :major)).to eq("2.0.0")
        end
      end

      describe "with build components" do
        let :version, do: "1.2.3+alpha"

        it "wipes the build on patch increment" do
          expect(Semver.increment(version, :patch)).to eq("1.2.4")
        end

        it "wipes the build on minor increment" do
          expect(Semver.increment(version, :minor)).to eq("1.3.0")
        end

        it "wipes the build on major increment" do
          expect(Semver.increment(version, :major)).to eq("2.0.0")
        end
      end
    end
  end

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
        {:ok, version} = Semver.parse("1.2.3")
        {:ok, version: version}
      end

      let :version, do: __.version

      it "parses the major version", do: version.major |> should eq 1
      it "parses the minor version", do: version.minor |> should eq 2
      it "parses the patch version", do: version.patch |> should eq 3
      it "gives an empty list for prerelease", do: version.prerelease |> should eq []
      it "gives an empty list for build", do: version.build |> should eq []
    end

    describe "a version including prerelease components" do
      before do
        {:ok, version} = Semver.parse("1.2.3-alpha.beta")
        {:ok, version: version}
      end

      let :version, do: __.version

      it "parses the major version", do: version.major |> should eq 1
      it "parses the minor version", do: version.minor |> should eq 2
      it "parses the patch version", do: version.patch |> should eq 3
      it "gives an empty list for prerelease", do: version.prerelease |> should eq ["alpha", "beta"]
      it "gives an empty list for build", do: version.build |> should eq []
    end

    describe "a version including build components" do
      before do
        {:ok, version} = Semver.parse("1.2.3+alpha.beta")
        {:ok, version: version}
      end

      let :version, do: __.version

      it "parses the major version", do: version.major |> should eq 1
      it "parses the minor version", do: version.minor |> should eq 2
      it "parses the patch version", do: version.patch |> should eq 3
      it "gives an empty list for prerelease", do: version.prerelease |> should eq []
      it "gives an empty list for build", do: version.build |> should eq ["alpha", "beta"]
    end

    describe "a version containing both prerelease and build components" do
      before do
        {:ok, version} = Semver.parse("1.2.3-alpha.beta+alpha.beta")
        {:ok, version: version}
      end

      let :version, do: __.version

      it "parses the major version", do: version.major |> should eq 1
      it "parses the minor version", do: version.minor |> should eq 2
      it "parses the patch version", do: version.patch |> should eq 3
      it "gives an empty list for prerelease", do: version.prerelease |> should eq ["alpha", "beta"]
      it "gives an empty list for build", do: version.build |> should eq ["alpha", "beta"]
    end
  end

  describe "parse!" do
    it "raises an error when the version is invalid" do
      expect(fn -> Semver.parse!("vvv") end).to raise_exception(Semver.Error)
    end

    describe "a valid version" do
      before do
        {:ok, version: Semver.parse!("1.2.3")}
      end

      let :version, do: __.version

      it "parses the major version", do: version.major |> should eq 1
      it "parses the minor version", do: version.minor |> should eq 2
      it "parses the patch version", do: version.patch |> should eq 3
      it "gives an empty list for prerelease", do: version.prerelease |> should eq []
      it "gives an empty list for build", do: version.build |> should eq []
    end
  end

  describe "to_string" do
    describe "bare version" do
      let :version, do: %Semver{major: 1, minor: 2, patch: 3}

      it "converts it to a string", do: expect(Semver.to_string(version)).to eq("1.2.3")
    end

    describe "a complex version" do
      let :version, do: %{major: 1, minor: 2, patch: 3, prerelease: ["alpha", "beta"], build: ["12", "345"]}

      it "converts a Semver struct into a string" do
        expect(Semver.to_string(version)).to eq("1.2.3-alpha.beta+12.345")
      end
    end
  end
end
