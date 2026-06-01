# Adback iOS SDK

Adback helps mobile apps attribute installs and subscription outcomes back to
paid campaigns.

This repository is the public Swift Package Manager package for the closed-source
Adback iOS SDK binary.

## Features

- Swift Package Manager install with a prebuilt `AdbackSDK.xcframework`
- Networked SDK configuration for production and development apps
- Automatic install resolve and automatic install event delivery
- Optional Apple Ads attribution handoff without requiring ATT
- Manual standard SDK event tracking with `Adback.track(...)`
- Safe no-crash behavior for missing or empty SDK keys
- RevenueCat, Superwall, App Store Server Notifications, and backend webhook
  friendly attribution handoff

The implementation source is private. This repository intentionally does not
contain SDK source code, server secrets, provider tokens, or backend matching
logic.

## Requirements

- iOS 15.0+
- Xcode 15+
- Swift 5.9+

## Installation

In Xcode:

1. Open **File > Add Package Dependencies**.
2. Enter the package URL:

```text
https://github.com/adback-app/ios-sdk
```

3. Select version `0.1.6` or the latest available release.
4. Add the `AdbackSDK` product to your app target.

## Initialization

```swift
import AdbackSDK

Adback.configure(apiKey: "adbk_pk_live_...")
```

`configure` fetches remote SDK config, resolves the install, and sends the
automatic install event in the background.

To enable Apple Ads attribution on iOS 14.3+:

```swift
Adback.enableAppleAdsAttribution()
```

This does not request App Tracking Transparency permission.

For development builds:

```swift
import AdbackSDK

Adback.configure(
  apiKey: "adbk_pk_test_...",
  options: .init(
    environment: .development,
    debug: true,
    logLevel: .debug
  )
)
```

Passing an empty or whitespace-only SDK key does not crash the host app. The SDK
clears local configuration and stays disabled until a valid key is configured.

## Events

```swift
Adback.track(.signUp)
Adback.track(.startTrial, properties: ["plan": .string("annual")])
```

Use `flush` in debug flows or tests when you need to wait for pending delivery:

```swift
await Adback.flush()
```

## Reset

Reset local SDK state when signing out, switching workspaces, or running tests:

```swift
Adback.reset()
```

## Revenue and Paywalls

Use Adback attribution values with RevenueCat, Superwall, or your own paywall
targeting. Send actual purchase and subscription revenue through RevenueCat,
Superwall, App Store Server Notifications, or your backend integration.

The mobile SDK does not expose SDK-side purchase, subscription, StoreKit capture,
manual revenue, transaction, or `transaction_details` APIs for the MVP.

## Privacy

The SDK does not collect IDFA by default, precise location, contacts, photos,
clipboard contents, or installed-app lists.

IDFV may be collected only as an optional app/environment-gated install, debug,
or match signal. User match data is sent only when your app passes it
explicitly.

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
