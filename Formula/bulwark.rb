# typed: false
# frozen_string_literal: true

# Homebrew formula for bulwark. On macOS the tarball is self-contained: the CLI plus
# the signed + notarized Endpoint Security gate bundle, and the CLI finds the gate
# automatically. On Linux the gate is fanotify (kernel built-in), so only the CLI ships.
class Bulwark < Formula
  desc "Kernel-boundary file-read gate for AI agent process trees"
  homepage "https://obstalabs.dev/bulwark"
  version "0.7.1"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/obstalabs/bulwark-dist/releases/download/v0.7.1/bulwark-0.7.1-x86_64-apple-darwin.tar.gz"
      sha256 "7ecab35038be5431c932de986ed662f071d590c76188b652b98ef873a53f54a9"

      define_method(:install) do
        bin.install "bulwark"
        libexec.install "bulwark_es_gate.app"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/obstalabs/bulwark-dist/releases/download/v0.7.1/bulwark-0.7.1-aarch64-apple-darwin.tar.gz"
      sha256 "5a4830c843e29a4d695dbb7d60a4818e84070c7c8eaa1f111de5ae690b742613"

      define_method(:install) do
        bin.install "bulwark"
        libexec.install "bulwark_es_gate.app"
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/obstalabs/bulwark-dist/releases/download/v0.7.1/bulwark-0.7.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7f98df33d1b6a933fbf4f7ea99f4c51199bd72e9b36be1711dc74e26d189c640"

      define_method(:install) do
        bin.install "bulwark"
      end
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/obstalabs/bulwark-dist/releases/download/v0.7.1/bulwark-0.7.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1a45a7de1bc5921f935ef4921494be3e31ff4156169ac7b1478d0cc5de3ac35a"

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
