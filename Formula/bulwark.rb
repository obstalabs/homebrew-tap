# typed: false
# frozen_string_literal: true

# Homebrew formula for bulwark. On macOS the tarball is self-contained: the CLI plus
# the signed + notarized Endpoint Security gate bundle, and the CLI finds the gate
# automatically. On Linux the gate is fanotify (kernel built-in), so only the CLI ships.
class Bulwark < Formula
  desc "Kernel-boundary file-read gate for AI agent process trees"
  homepage "https://obstalabs.dev/bulwark"
  version "0.11.1"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/obstalabs/bulwark/releases/download/v0.11.1/bulwark-0.11.1-x86_64-apple-darwin.tar.gz"
      sha256 "7bf83d768aa29818a0d1f3add6194bc66053c7619a379511ac5eadd684dc0931"

      define_method(:install) do
        bin.install "bulwark"
        libexec.install "bulwark_es_gate.app"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/obstalabs/bulwark/releases/download/v0.11.1/bulwark-0.11.1-aarch64-apple-darwin.tar.gz"
      sha256 "f8d2e770799df262b87df27525ae2f6381cc4a3cb2cc17ac94735fa6e1de4b55"

      define_method(:install) do
        bin.install "bulwark"
        libexec.install "bulwark_es_gate.app"
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/obstalabs/bulwark/releases/download/v0.11.1/bulwark-0.11.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "397b56b304dc2d6368ae3dd8f236629cd009f5c9294bf93be5b7bf74b53debe9"

      define_method(:install) do
        bin.install "bulwark"
      end
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/obstalabs/bulwark/releases/download/v0.11.1/bulwark-0.11.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "452a4e6c2d95429054b431083016eab4e8203c9b0ba653291bbe983f1a1f34ac"

      define_method(:install) do
        bin.install "bulwark"
      end
    end
  end

  def caveats
    <<~EOS
      Since 0.11.0 bulwark refuses to run as root from a path a non-root user can
      modify, which includes the Homebrew prefix. Install a root-owned engine once
      and use the path it prints for privileged runs:
        sudo "$(brew --prefix)/bin/bulwark" install-root

      Linux: the gate is fully functional (fanotify). Run as root for protected reads:
        sudo <installed> run --protect ~/.ssh -- <agent>

      macOS: kernel enforcement uses a signed Endpoint Security gate, installed with
      this formula (the CLI finds it automatically — no setup needed).

      REQUIRED on macOS: grant Full Disk Access to your terminal app, or the gate
      cannot start (you'll see "es_new_client failed: 4"). System Settings ->
      Privacy & Security -> Full Disk Access -> add your terminal -> then fully quit
      and reopen it.

      Then (run as root, with the path install-root printed):
        sudo "$(brew --prefix)/bin/bulwark" doctor
        sudo <installed> run --protect ~/.ssh -- <agent>

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
