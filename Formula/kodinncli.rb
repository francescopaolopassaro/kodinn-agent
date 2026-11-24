class Kodinncli < Formula
  desc "Kodinn Agent: a terminal AI coding agent (cloud and local models, plan/build modes, git, MCP)."
  homepage "https://www.digitalsolutions.it"
  version "0.9.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://www.digitalsolutions.it/downloads/kodinncli/0.9.6/KodinnCli-0.9.6-osx-arm64.tar.gz"
      sha256 "3ce570c776002cdcba7b53fcfa67973db502f60236ad9dda46ee5204af831273"
    end
    on_intel do
      url "https://www.digitalsolutions.it/downloads/kodinncli/0.9.6/KodinnCli-0.9.6-osx-x64.tar.gz"
      sha256 "4f12d3bac5b746db01a62c4a27f49906b70aaf504399fd04fc6c55cc16f2ffc9"
    end
  end

  on_linux do
    on_arm do
      url "https://www.digitalsolutions.it/downloads/kodinncli/0.9.6/KodinnCli-0.9.6-linux-arm64.tar.gz"
      sha256 "2a872eb92e80e087a16e59292b97416270f9b2a0830caa92f8243f6c16dd77ac"
    end
    on_intel do
      url "https://www.digitalsolutions.it/downloads/kodinncli/0.9.6/KodinnCli-0.9.6-linux-x64.tar.gz"
      sha256 "a764e7c1926cc5d456f8bd75d478e7f36a1a66773cbc953b5a9a478c470e1169"
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
