class Hostkeep < Formula
  desc "Terminal UI editor for /etc/hosts: toggle, group and edit entries safely, with backups and diff preview"
  homepage "https://github.com/volodymyr-malishevskyi/hostkeep"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/volodymyr-malishevskyi/hostkeep/releases/download/v0.2.1/hostkeep-aarch64-apple-darwin.tar.xz"
      sha256 "4a343bf5d3e1b59f48b0bb4e4cc8c614669d4702a50d4bd97e2e4139bd630a94"
    end
    if Hardware::CPU.intel?
      url "https://github.com/volodymyr-malishevskyi/hostkeep/releases/download/v0.2.1/hostkeep-x86_64-apple-darwin.tar.xz"
      sha256 "77f1158529dec23330065cc97c56a130377be00c6b28f33c881736ddf0dcc0bc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/volodymyr-malishevskyi/hostkeep/releases/download/v0.2.1/hostkeep-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1c3877bfb3e26d5f7fdf85f41b8bff68fc164b73faa1f8c4de1dca8970be6947"
    end
    if Hardware::CPU.intel?
      url "https://github.com/volodymyr-malishevskyi/hostkeep/releases/download/v0.2.1/hostkeep-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a0923d11809f2b5c78047afd13c3c76920a94bff82d922f81a5423b77f227a6e"
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
