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

  version "0.11.1"
  sha256 arm:   "3b0f025288b55fec77c996ee1aa0a0146a5ab2e431074dd9e0131a10f54a220e",
         intel: "5b0056724a79a07a9924f255e8d66b13978c02087f0638a66138ad925c0ef1a6"

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
