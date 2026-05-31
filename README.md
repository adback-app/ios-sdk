# Adback iOS SDK

Adback attributes app installs and subscription revenue back to paid campaigns.
This repository is the public Swift Package Manager wrapper for the closed-source
Adback iOS SDK binary.

## Install

In Xcode:

1. Open **File > Add Package Dependencies**.
2. Enter the package URL:

```text
https://github.com/adback-app/ios-sdk
```

3. Select version `0.1.0` or the latest available release.
4. Add the `AdbackSDK` product to your app target.

## Current Release

`0.1.0` is the MVP package release for validating the public SwiftPM install path
and the initial SDK API surface. It includes:

- A checked-in `AdbackSDK.xcframework` binary target.
- Bootstrap configuration APIs.
- Snake_case v1 SDK event/config payload models.
- Privacy and revenue boundaries for the MVP contract.

The implementation source is private. This repository intentionally does not
contain SDK source code, server secrets, provider tokens, or backend matching
logic.

## Quickstart

```swift
import AdbackSDK

Adback.configure(apiKey: "adbk_pk_live_...")
```

For development or staging builds, configure explicit options:

```swift
import AdbackSDK

Adback.configure(
  apiKey: "adbk_pk_test_...",
  options: .init(
    environment: .development,
    apiBaseURL: URL(string: "https://api.adback.app")!,
    debug: true,
    logLevel: .debug
  )
)
```

You can reset local SDK configuration when signing out, changing tenants, or
running tests:

```swift
Adback.reset()
```

## Network Boundary

The SDK talks to the Adback API host:

```text
GET  https://api.adback.app/v1/sdk/config
POST https://api.adback.app/v1/sdk/installs/resolve
POST https://api.adback.app/v1/sdk/events
```

`adback.link` is only for tracking links and redirects before the App Store
handoff. The iOS SDK does not call `adback.link`.

## Event Boundary

MVP SDK events are for install and funnel signals:

- Install
- Signup
- Checkout intent
- Trial start
- Custom funnel/debug events

SDK event payloads use `schema_version: 1` and snake_case wire fields.

Do not send purchase or subscription revenue through the mobile SDK. Revenue
truth should come from RevenueCat, Superwall, App Store Server Notifications, or
your backend webhook/API events.

The mobile SDK does not expose SDK-side purchase, subscription, StoreKit capture,
manual revenue, transaction, or `transaction_details` APIs for the MVP.

## RevenueCat and Superwall

Use Adback attribution values with RevenueCat, Superwall, or your own paywall
targeting. Send actual purchase/subscription revenue through RevenueCat,
Superwall, App Store Server Notifications, or your backend integration.

## Privacy

The SDK does not collect IDFA by default, precise location, contacts, photos,
clipboard contents, or installed-app lists.

IDFV may be collected only as an optional app/environment-gated install, debug,
or match signal. User match data is sent only when your app passes it
explicitly. The Adback backend normalizes and hashes user match data before
provider postbacks.

ASA tokens are used only for install resolution on the Apple Ads attribution
path. They are not sent in normal event metadata.

## Signing

You do not need to sign this package with your Apple Developer account before
adding it in Xcode. The consuming app signs embedded frameworks as part of its
normal app build and archive process.

## Troubleshooting

If Xcode fails to resolve the package:

- Confirm the URL is `https://github.com/adback-app/ios-sdk`.
- Confirm your project supports iOS 15 or newer.
- Remove stale SwiftPM cache entries from Xcode and resolve packages again.
- Make sure your app target links the `AdbackSDK` product.

## Support

Dashboard: https://console.adback.app
