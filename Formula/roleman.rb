class Roleman < Formula
  desc "AWS SSO role selector that exports shell credentials"
  homepage "https://github.com/fiam/roleman"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fiam/roleman/releases/download/v0.1.0/roleman-aarch64-apple-darwin.tar.xz"
      sha256 "a9c354e553b12d620bb11ca0f47faf354ff82d6afc2427e8759bf648e9abe6a9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fiam/roleman/releases/download/v0.1.0/roleman-x86_64-apple-darwin.tar.xz"
      sha256 "923256e4fee68691c95fd7a8826820e9d5b47867ba7542da890458029c8fe346"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/fiam/roleman/releases/download/v0.1.0/roleman-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "27a55df99f01990a69ef13d9468a95fd339688d944280fb4a2f41bb33a3d1680"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
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
