# typed: false
# frozen_string_literal: true

# Homebrew formula for bulwark. On macOS the tarball is self-contained: the CLI plus
# the signed + notarized Endpoint Security gate bundle, and the CLI finds the gate
# automatically. On Linux the gate is fanotify (kernel built-in), so only the CLI ships.
class Bulwark < Formula
  desc "Kernel-boundary file-read gate for AI agent process trees"
  homepage "https://obstalabs.dev/bulwark"
  version "0.9.1"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/obstalabs/bulwark/releases/download/v0.9.1/bulwark-0.9.1-x86_64-apple-darwin.tar.gz"
      sha256 "a9561c54d983dbb542be515f1aa355fd358714dbdd3bff8d6878688a68f40f8a"

      define_method(:install) do
        bin.install "bulwark"
        libexec.install "bulwark_es_gate.app"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/obstalabs/bulwark/releases/download/v0.9.1/bulwark-0.9.1-aarch64-apple-darwin.tar.gz"
      sha256 "fb7f7f765fbb6eca53bfd93bacb4deafc3af93d527343be671c48d21cb1fddde"

      define_method(:install) do
        bin.install "bulwark"
        libexec.install "bulwark_es_gate.app"
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/obstalabs/bulwark/releases/download/v0.9.1/bulwark-0.9.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3ca51962c4ea2a93d21ccfa879e19f7e252d89717850e598c73f6d7675e62015"

      define_method(:install) do
        bin.install "bulwark"
      end
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/obstalabs/bulwark/releases/download/v0.9.1/bulwark-0.9.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bcf2112969e84f2f140e495bf05e9507cb8e8239bfea6fa68ca074170f4d514c"

      define_method(:install) do
        bin.install "bulwark"
      end
    end
  end

  def caveats
    <<~EOS
      Linux: the gate is fully functional (fanotify). Run as root for protected reads:
        sudo bulwark run --protect ~/.ssh -- <agent>

      macOS: kernel enforcement uses a signed Endpoint Security gate, installed with
      this formula (the CLI finds it automatically — no setup needed).

      REQUIRED on macOS: grant Full Disk Access to your terminal app, or the gate
      cannot start (you'll see "es_new_client failed: 4"). System Settings ->
      Privacy & Security -> Full Disk Access -> add your terminal -> then fully quit
      and reopen it.

      Then (run as root):
        sudo bulwark doctor
        sudo bulwark run --protect ~/.ssh -- <agent>

      If sudo reports "bulwark: command not found", sudo's secure_path excludes
      Homebrew's bin. Run it by full path:
        sudo "$(brew --prefix)/bin/bulwark" doctor

      Advanced: override the gate location with BULWARK_MACOS_ES_GATE if needed.
    EOS
  end

  test do
    assert_match "bulwark", shell_output("#{bin}/bulwark --version")
  end
end
