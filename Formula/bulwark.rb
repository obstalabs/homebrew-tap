# typed: false
# frozen_string_literal: true

# Homebrew formula for bulwark. On macOS the tarball is self-contained: the CLI plus
# the signed + notarized Endpoint Security gate bundle, and the CLI finds the gate
# automatically. On Linux the gate is fanotify (kernel built-in), so only the CLI ships.
class Bulwark < Formula
  desc "Kernel-boundary file-read gate for AI agent process trees"
  homepage "https://obstalabs.dev/bulwark"
  version "0.10.0"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/obstalabs/bulwark/releases/download/v0.10.0/bulwark-0.10.0-x86_64-apple-darwin.tar.gz"
      sha256 "1b5ea4abea6ff30b0989497da9f993a6994b59870161c41980e8e8320adeeedb"

      define_method(:install) do
        bin.install "bulwark"
        libexec.install "bulwark_es_gate.app"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/obstalabs/bulwark/releases/download/v0.10.0/bulwark-0.10.0-aarch64-apple-darwin.tar.gz"
      sha256 "b8ce5ac56273971af01cabc51a67452db523923ca7250c9e2797f681d7d4c3ce"

      define_method(:install) do
        bin.install "bulwark"
        libexec.install "bulwark_es_gate.app"
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/obstalabs/bulwark/releases/download/v0.10.0/bulwark-0.10.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f69702ef7f8026c670d5147f41b83a89456b032ff985da1576432176bc240a3d"

      define_method(:install) do
        bin.install "bulwark"
      end
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/obstalabs/bulwark/releases/download/v0.10.0/bulwark-0.10.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ea31912ff4c763c6250126ee86fb8aeb9edff32b28c8b5e802c94e936b7add2e"

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
