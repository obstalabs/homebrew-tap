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

  version "0.9.2"
  sha256 arm:   "8843f5efb179cb1cc9c59b390c9c9c38aa6a19076de3b4c1b5a10e8d6ebc9230",
         intel: "436ef3322bf42432a8967e183db17f98679a00b1138502d6c22beb7e2b1847d7"

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
