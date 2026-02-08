class Roleman < Formula
  desc "AWS SSO role selector that exports shell credentials"
  homepage "https://github.com/fiam/roleman"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fiam/roleman/releases/download/v0.2.0/roleman-aarch64-apple-darwin.tar.xz"
      sha256 "8db776b337fcc8e5ae0fd75def381ac7d6f4a0ab16f361e54c8cd38a0bb84a0f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fiam/roleman/releases/download/v0.2.0/roleman-x86_64-apple-darwin.tar.xz"
      sha256 "f0c3720164692b0619fd32f37819fd83f48706ac0982637f2cdf9cfa759f710f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fiam/roleman/releases/download/v0.2.0/roleman-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b5d88c83ddd4acf29f20d7e960b9114875ffaf62761ab1b94218c218feab78d6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fiam/roleman/releases/download/v0.2.0/roleman-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dd2b1c71565295e5d7e16c657d8deea328c3cb359018ff4f44bd150e98966e24"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "roleman" if OS.mac? && Hardware::CPU.arm?
    bin.install "roleman" if OS.mac? && Hardware::CPU.intel?
    bin.install "roleman" if OS.linux? && Hardware::CPU.arm?
    bin.install "roleman" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
