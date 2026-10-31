class Hostkeep < Formula
  desc "Terminal UI editor for /etc/hosts: toggle, group and edit entries safely, with backups and diff preview"
  homepage "https://github.com/volodymyr-malishevskyi/hostkeep"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/volodymyr-malishevskyi/hostkeep/releases/download/v0.2.0/hostkeep-aarch64-apple-darwin.tar.xz"
      sha256 "140b93228582706a6d24024d271502c79234222c3560ffc0339ba8e0c7bd98d8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/volodymyr-malishevskyi/hostkeep/releases/download/v0.2.0/hostkeep-x86_64-apple-darwin.tar.xz"
      sha256 "e465719da090d132cbbbbe78c761cd2659f7f3411fec145de204e23a76a5adda"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/volodymyr-malishevskyi/hostkeep/releases/download/v0.2.0/hostkeep-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "276024dc33773410c6570e86b23bc3ca083f5e69f812dcd764c526468deb6aca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/volodymyr-malishevskyi/hostkeep/releases/download/v0.2.0/hostkeep-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b8a57420ef8b09798ab28d0d62e052ef341c51243b794abcd139cd11af1bdc9f"
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
