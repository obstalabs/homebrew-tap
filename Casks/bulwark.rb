# typed: false
# frozen_string_literal: true

# Optional pkg-based install channel for the bulwark CLI:
#   brew install --cask obstalabs/tap/bulwark
#
# This installs the signed + notarized + stapled .pkg (offline-trusted), which
# places bulwark in /usr/local/bin. Most users should prefer the FORMULA
# (`brew install obstalabs/tap/bulwark`) — it installs into the Homebrew prefix
# the Homebrew-native way. This cask exists for those who want the installer
# package / offline-stapled artifact.
#
# The macOS Endpoint Security gate bundle is distributed separately; run
# `bulwark doctor` for setup.
cask "bulwark" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.11.0"
  sha256 arm:   "528a12812847fa056f6a9828d19a2b5bbcc7023cd11db363a819dc6443a58676",
         intel: "b41f6c256d653a8a593ac9136873685fd548f242013e6e103775d78b9f9d49c1"

  url "https://github.com/obstalabs/bulwark/releases/download/v#{version}/bulwark-#{version}-#{arch}-apple-darwin.pkg"
  name "Bulwark"
  desc "Kernel-boundary file-read gate for AI agent process trees"
  homepage "https://obstalabs.dev/bulwark"

  pkg "bulwark-#{version}-#{arch}-apple-darwin.pkg"

  uninstall pkgutil: "dev.obstalabs.bulwark"

  caveats <<~EOS
    macOS kernel enforcement additionally requires the signed Endpoint Security
    gate bundle (distributed separately). After installing it, point the CLI at it:
      export BULWARK_MACOS_ES_GATE=/path/to/bulwark_es_gate.app/Contents/MacOS/bulwark_es_gate
    Then check setup with: bulwark doctor
  EOS
end
