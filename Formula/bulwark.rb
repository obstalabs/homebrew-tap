# typed: false
# frozen_string_literal: true

# Homebrew formula for the bulwark CLI. The macOS Endpoint Security gate bundle
# (signed, notarized, entitled .app) is distributed separately — this formula
# ships only the portable CLI. See `bulwark doctor` for the macOS gate setup.
class Bulwark < Formula
  desc "Kernel-boundary file-read gate for AI agent process trees"
  homepage "https://obstalabs.dev/bulwark"
  version "0.7.0"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/obstalabs/bulwark-dist/releases/download/v0.7.0/bulwark-0.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "1f0f5ac574970aa584f9f4567e9b84f855eb6fe825036a442f3642c0875585cc"

      define_method(:install) do
        bin.install "bulwark"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/obstalabs/bulwark-dist/releases/download/v0.7.0/bulwark-0.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "07458e4e0ec1d62d091992b8c2545c864f57644f251ab724bcbee608f9a29671"

      define_method(:install) do
        bin.install "bulwark"
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/obstalabs/bulwark-dist/releases/download/v0.7.0/bulwark-0.7.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "374eb6a139c098a9fa30aa544976f0ecfe32f4c7f40cc73cb831d417da7c8693"

      define_method(:install) do
        bin.install "bulwark"
      end
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/obstalabs/bulwark-dist/releases/download/v0.7.0/bulwark-0.7.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e89d76ef09740fadb1548beed246480ce40dd0a581a9b9e1b4d5cdcfb111ab9f"

      define_method(:install) do
        bin.install "bulwark"
      end
    end
  end

  def caveats
    <<~EOS
      Linux: the gate is fully functional (fanotify). Run as root for protected reads:
        sudo bulwark run --protect ~/.ssh -- <agent>

      macOS: this installs the bulwark CLI. Kernel enforcement additionally requires
      the signed Endpoint Security gate bundle (distributed separately — it is an
      entitled, notarized .app and needs Full Disk Access + root). After installing
      that bundle, point the CLI at it:
        export BULWARK_MACOS_ES_GATE=/path/to/bulwark_es_gate.app/Contents/MacOS/bulwark_es_gate

      Check your setup any time:
        bulwark doctor
    EOS
  end

  test do
    assert_match "bulwark", shell_output("#{bin}/bulwark --version")
  end
end
