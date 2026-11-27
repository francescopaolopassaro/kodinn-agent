class Kodinncli < Formula
  desc "Kodinn Agent: a terminal AI coding agent (cloud and local models, plan/build modes, git, MCP)."
  homepage "https://www.digitalsolutions.it"
  version "0.9.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://www.digitalsolutions.it/downloads/kodinncli/0.9.7/KodinnCli-0.9.7-osx-arm64.tar.gz"
      sha256 "b9af1af2784253701e62d6480f59aee756058528bbed7a721f84176be2d62370"
    end
    on_intel do
      url "https://www.digitalsolutions.it/downloads/kodinncli/0.9.7/KodinnCli-0.9.7-osx-x64.tar.gz"
      sha256 "40d36890a4772e4b58d46ce883f501c3a9e0a8671fbcfe6f92c69382b053a696"
    end
  end

  on_linux do
    on_arm do
      url "https://www.digitalsolutions.it/downloads/kodinncli/0.9.7/KodinnCli-0.9.7-linux-arm64.tar.gz"
      sha256 "41c5ebcabcc175c7e5a9956d40debd699d62fb5705736ffa7d43524e393d9a28"
    end
    on_intel do
      url "https://www.digitalsolutions.it/downloads/kodinncli/0.9.7/KodinnCli-0.9.7-linux-x64.tar.gz"
      sha256 "a50f75f3c6d333ac14ce24ad21b50b7f62725fefeb80d058ea1c534ffe94cca7"
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
