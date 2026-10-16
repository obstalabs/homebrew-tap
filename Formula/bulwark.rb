# typed: false
# frozen_string_literal: true

# Homebrew formula for bulwark. On macOS the tarball is self-contained: the CLI plus
# the signed + notarized Endpoint Security gate bundle, and the CLI finds the gate
# automatically. On Linux the gate is fanotify (kernel built-in), so only the CLI ships.
class Bulwark < Formula
  desc "Kernel-boundary file-read gate for AI agent process trees"
  homepage "https://obstalabs.dev/bulwark"
  version "0.9.3"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/obstalabs/bulwark/releases/download/v0.9.3/bulwark-0.9.3-x86_64-apple-darwin.tar.gz"
      sha256 "b1a5bd843f39ccc1a5146260d6906cfed59d019de54b1fbbcec546c4796b059f"

      define_method(:install) do
        bin.install "bulwark"
        libexec.install "bulwark_es_gate.app"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/obstalabs/bulwark/releases/download/v0.9.3/bulwark-0.9.3-aarch64-apple-darwin.tar.gz"
      sha256 "c3d52e236c69d83d29de2fbbda17e5cff5743dc198de3c03d8267e05093cecfd"

      define_method(:install) do
        bin.install "bulwark"
        libexec.install "bulwark_es_gate.app"
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/obstalabs/bulwark/releases/download/v0.9.3/bulwark-0.9.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8322d0e36f1997932bdc783764ff25b43277a271e54ec1f0de4b88b5678fb9b6"

      define_method(:install) do
        bin.install "bulwark"
      end
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/obstalabs/bulwark/releases/download/v0.9.3/bulwark-0.9.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c5356b87eca2c61b090f68ac0e1ad2395300687a450e7d4e47a4a310df9af8e9"

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
