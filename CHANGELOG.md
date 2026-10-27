# Changelog

All notable changes to this tap are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/). The tap itself is not
versioned: entries are dated and name the formula or cask version they ship.
Release automation in the upstream repositories also bumps some formulas directly;
those bumps are recorded in git history.

## [Unreleased]

## 2026-10-27

### Changed
- `workledger` formula ships 0.61.0.

## 2026-10-25

### Changed
- `workledger` formula (0.60.1) takes the canonical shape the shared release publisher
  writes: it declares `license "Proprietary"`, requires `rbconfig` explicitly, and its
  description reads "System of record for AI-assisted work: work orders, claims,
  evidence, sign-off". Download URLs and checksums are unchanged.

## 2026-10-16

### Changed
- `bulwark` formula and cask bumped to 0.9.3 (security release). The macOS
  tarballs bundle the signed and notarized Endpoint Security gate app; the cask
  installs the signed, notarized and stapled `.pkg`.
