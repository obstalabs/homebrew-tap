# Changelog

All notable changes to this tap are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/). The tap itself is not
versioned: entries are dated and name the formula or cask version they ship.
Release automation in the upstream repositories also bumps some formulas directly;
those bumps are recorded in git history.

## [Unreleased]

## 2026-10-16

### Changed
- `bulwark` formula and cask bumped to 0.9.3 (security release). The macOS
  tarballs bundle the signed and notarized Endpoint Security gate app; the cask
  installs the signed, notarized and stapled `.pkg`.
