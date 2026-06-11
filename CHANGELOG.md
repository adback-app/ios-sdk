# Changelog

All notable changes to the Adback iOS SDK appear in this file.

## Unreleased

## 0.1.8 - 2026-06-11

### Added

- Added wrapper name and version reporting for React Native and Flutter SDKs.

## 0.1.7 - 2026-06-01

### Added

- Added `Adback.getAdbackId()` and `Adback.getAttributionParams()` for attribution handoff integrations.

## 0.1.6 - 2026-06-01

### Added

- Added optional Apple Ads attribution through `Adback.enableAppleAdsAttribution()`.

## 0.1.5 - 2026-06-01

### Changed

- Improved SDK bootstrap compatibility.

## 0.1.4 - 2026-06-01

### Changed

- Improved install matching reliability.

## 0.1.3 - 2026-06-01

### Changed

- Improved remote configuration and install matching compatibility.

## 0.1.2 - 2026-06-01

### Added

- Added remote SDK configuration and automatic install delivery.
- Added `Adback.track(...)` and `Adback.flush()` for manual event delivery.

### Reliability

- Invalid SDK keys now disable the SDK without crashing the host app.

## 0.1.1 - 2026-05-31

### Fixed

- Invalid SDK keys now disable the SDK without crashing the host app.

### Documentation

- Expanded installation, privacy, signing, and troubleshooting guidance.

## 0.1.0 - 2026-05-31

### Added

- Published the initial Adback iOS SDK binary package.
- Added Swift Package Manager installation, device and simulator support, and integration documentation.
