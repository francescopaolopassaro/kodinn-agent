class Kodinncli < Formula
  desc "Kodinn Agent: a terminal AI coding agent (cloud and local models, plan/build modes, git, MCP)."
  homepage "https://www.digitalsolutions.it"
  version "0.9.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://www.digitalsolutions.it/downloads/kodinncli/0.9.4/KodinnCli-0.9.4-osx-arm64.tar.gz"
      sha256 "e6ab3fb6514516a89d8f1b35828d783df2bc00fb1bdba870b6c3ffd28c966878"
    end
    on_intel do
      url "https://www.digitalsolutions.it/downloads/kodinncli/0.9.4/KodinnCli-0.9.4-osx-x64.tar.gz"
      sha256 "f2518171566471697fca0262505250405bbcf1fedfdea557ea44d2e24f753f43"
    end
  end

  on_linux do
    on_arm do
      url "https://www.digitalsolutions.it/downloads/kodinncli/0.9.4/KodinnCli-0.9.4-linux-arm64.tar.gz"
      sha256 "26d1b1e331cc395ac2088445907338a8ef4067d2bc4247f8fcef1d072f360bbf"
    end
    on_intel do
      url "https://www.digitalsolutions.it/downloads/kodinncli/0.9.4/KodinnCli-0.9.4-linux-x64.tar.gz"
      sha256 "b724bbe7d5bbe910bb6916f93fa4e1a491cb53534890831fc33255f993087aac"
    end
  end

  def install
    libexec.install Dir["*"]
    chmod 0755, libexec/"KodinnCli"
    bin.install_symlink libexec/"KodinnCli" => "kodinn"
    bin.install_symlink libexec/"KodinnCli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/KodinnCli --version")
  end
end
