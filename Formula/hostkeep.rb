class Hostkeep < Formula
  desc "Terminal UI editor for /etc/hosts: toggle, group and edit entries safely, with backups and diff preview"
  homepage "https://github.com/volodymyr-malishevskyi/hostkeep"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/volodymyr-malishevskyi/hostkeep/releases/download/v0.1.0/hostkeep-aarch64-apple-darwin.tar.xz"
      sha256 "b542f978556b0e0b32423e99d613ea59bfb8ece4720352c115b2542c3b3bc90b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/volodymyr-malishevskyi/hostkeep/releases/download/v0.1.0/hostkeep-x86_64-apple-darwin.tar.xz"
      sha256 "d30df3d5a1bfa1092b0fd8baca579623e951e856dd06ef8bcf398e51ed4826f4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/volodymyr-malishevskyi/hostkeep/releases/download/v0.1.0/hostkeep-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "196d74d5ae5386fdd3a9e34dccb5df73817e17645b9797e4715f649a220e986c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/volodymyr-malishevskyi/hostkeep/releases/download/v0.1.0/hostkeep-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "054a2c6923a0e1d1b5bff1ab5cc993c2fe04e6def348a5cf7da526d4f8125aed"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "hostkeep"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "hostkeep"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "hostkeep"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "hostkeep"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
