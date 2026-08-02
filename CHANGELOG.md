# Changelog

All notable changes to the Adback iOS SDK appear in this file.

## Unreleased

## 0.3.3 - 2026-08-02

### Changed

- Improved reinstall detection and attribution reliability.
- Improved event delivery during initialization, offline use, and large bursts.

### Reliability

- Improved pending event recovery after upgrades, interrupted writes, and damaged local state.
- Hardened SDK state, reset, and callback delivery under concurrent use.
- Reduced memory use for large events and responses.
- Improved attribution retries during temporary connectivity failures.

### Developer Experience

- Added Swift strict-concurrency validation.
- Clarified supported Apple platforms.

## 0.3.2 - 2026-08-02

### Reliability

- Improved install response compatibility and delayed attribution recovery.
- Improved pending event isolation across SDK configurations.
- Improved behavior after malformed local state and reset.

## 0.3.1 - 2026-08-01

### Added

- Improved reinstall detection and attribution accuracy.
- Added guidance for identity, standard events, and safe SDK reset.

### Reliability

- Improved pending event recovery and concurrent client behavior.
- Fixed callback and retry handling during reset and temporary failures.

## 0.3.0 - 2026-07-30

### Added

- Added durable attribution retries for delayed install results.
- Added foreground retry resumption.

### Changed

- `Adback.reset()` now preserves installation identity while clearing configuration, attribution, and pending events.

### Reliability

- Improved retry consistency across restarts and temporary connectivity failures.
- Improved compatibility with older backend responses.
- Kept Apple Ads refresh independent from general attribution retries.

## 0.2.0 - 2026-07-22

### Added

- Added `refreshAttribution()` and attribution update handlers.

### Changed

- Improved Swift module compatibility for supported Xcode versions.

### Reliability

- Improved event delivery across restarts and connectivity changes.
- Added bounded retention and local protection for pending events.

## 0.1.10 - 2026-06-22

### Added

- Added custom event tracking and manual event delivery controls.

### Changed

- Events sent before SDK initialization now wait until the SDK is ready.
- Attribution results now return without waiting for event delivery.
- Updated SDK privacy declarations and integration guidance.

### Reliability

- Improved remote configuration compatibility and event retry behavior.

## 0.1.9 - 2026-06-21

### Reliability

- Improved SDK safety during configuration, reset, Apple Ads attribution, and manual event delivery.

### Documentation

- Simplified the public integration guide.

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
