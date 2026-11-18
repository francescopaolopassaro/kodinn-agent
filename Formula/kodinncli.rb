class Kodinncli < Formula
  desc "Kodinn Agent: a terminal AI coding agent (cloud and local models, plan/build modes, git, MCP)."
  homepage "https://www.digitalsolutions.it"
  version "0.9.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://www.digitalsolutions.it/downloads/kodinncli/0.9.5/KodinnCli-0.9.5-osx-arm64.tar.gz"
      sha256 "f14ba43c1a617b4ba19233c73ee5f55f64065d13b309f7955fdc3e162cc6f869"
    end
    on_intel do
      url "https://www.digitalsolutions.it/downloads/kodinncli/0.9.5/KodinnCli-0.9.5-osx-x64.tar.gz"
      sha256 "1029849de81cac11856ddea2f399865f130f4d81858909ecfd4f3f55f4fe788a"
    end
  end

  on_linux do
    on_arm do
      url "https://www.digitalsolutions.it/downloads/kodinncli/0.9.5/KodinnCli-0.9.5-linux-arm64.tar.gz"
      sha256 "8285a38c9ad18ba0493cbfa0d834c95408f049df1cba6a5ba1698b835f6a3017"
    end
    on_intel do
      url "https://www.digitalsolutions.it/downloads/kodinncli/0.9.5/KodinnCli-0.9.5-linux-x64.tar.gz"
      sha256 "8a84c3bc94c163576303bc6a85596593c407aa8f2c1fff5edf8d28f589149c54"
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
