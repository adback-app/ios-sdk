# Adback iOS SDK

Adback helps mobile apps attribute installs and subscription outcomes back to
paid campaigns.

This repository is the public Swift Package Manager package for the closed-source
Adback iOS SDK binary.

## Features

- Swift Package Manager install with a prebuilt `AdbackSDK.xcframework`
- Networked SDK configuration for production and development apps
- Automatic install resolve and automatic install event delivery
- Durable install-attribution settlement retries across foreground sessions
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

3. Select version `0.3.3` or the latest available release.
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
Adback.track("paywall_viewed", properties: ["surface": .string("onboarding")])
```

`INSTALL` is sent automatically during configuration. Do not send it with
`Adback.track`; duplicate manual install calls are ignored.
Manual events are queued locally and retried by `flush`, future `track` calls,
and the next successful configuration.

Send login and signup identity through `AdbackUser`. Do not put identity fields
inside `properties`:

```swift
let user = AdbackUser(
  customerUserID: "user_123",
  matchData: .init(
    email: "person@example.com",
    externalID: "account_123"
  )
)

Adback.track(.login, properties: ["method": .string("apple")], user: user)
Adback.track(.signUp, properties: ["plan": .string("annual")], user: user)
```

The SDK does not keep a global signed-in user. Pass `user` on each event that
needs identity. Use a stable internal identifier for `customerUserID`.

Standard events are `LOGIN`, `SIGN_UP`, `ADD_TO_CART`, `ADD_TO_WISHLIST`,
`INITIATE_CHECKOUT`, `START_TRIAL`, `LEVEL_START`, `LEVEL_COMPLETE`,
`TUTORIAL_COMPLETE`, `SEARCH`, `VIEW_ITEM`, `VIEW_CONTENT`, and `SHARE`.

Use `flush` in debug flows or tests when you need to wait for pending delivery:

```swift
await Adback.flush()
```

## Attribution Handoff

Use `getAttributionParams()` after configuration to pass Adback attribution
values into paywall or revenue SDK user attributes:

```swift
if let attributes = await Adback.getAttributionParams() {
  Purchases.shared.setAttributes(attributes)

  let superwallAttributes: [String: Any?] = attributes.mapValues { $0 }
  Superwall.shared.setUserAttributes(superwallAttributes)
}
```

`getAttributionParams()` waits for the initial SDK bootstrap if it is still in
flight. `Adback.getAdbackId()` returns the resolved Adback join ID once
available.

Apple Ads token resolution finishes asynchronously. Subscribe to changed
best-known values, or request an explicit serialized status refresh:

```swift
Adback.setAttributionUpdateHandler { attributes in
  Purchases.shared.setAttributes(attributes)
}

let latest = await Adback.refreshAttribution()
```

The SDK also performs a bounded background refresh after a queued Apple Ads
token submission. Status refreshes never resend the raw AdServices token. The
handler runs on one serial SDK callback queue; move UI work to `MainActor`.

The base attribute keys are `adback_id`, `adback_match_confidence`, and
`adback_source`. Paid-click matches may also include campaign, ad group, ad,
creative, keyword, click, landing, deeplink, and network keys. Missing values
are omitted.

## Reset

Reset SDK configuration, attribution, and queued events only when disconnecting
Adback, switching API keys, or running tests:

```swift
Adback.reset()
```

`reset()` preserves the install identity and immutable first-open time. A later
configuration continues the same installation.

Do not call `reset()` for a routine user logout. The SDK stores no global user,
and `reset()` removes events that still wait for delivery.

## Revenue and Paywalls

Use Adback attribution values with RevenueCat, Superwall, or your own paywall
targeting. Send actual purchase and subscription revenue through RevenueCat,
Superwall, App Store Server Notifications, or your backend integration.

The mobile SDK does not expose SDK-side purchase, subscription, StoreKit
transaction capture, manual revenue, transaction, or `transaction_details`
APIs for the MVP.

## React Native and Flutter Wrappers

Adback's React Native and Flutter packages wrap this iOS binary SDK on iOS.
Those wrappers set SDK wrapper metadata internally so events can be identified
as React Native or Flutter traffic without requiring extra app code.

## Privacy

The SDK does not collect IDFA by default, precise location, contacts, photos,
clipboard contents, or installed-app lists.

For reinstall attribution, the SDK collects IDFV evidence, persistent Keychain
UUIDs, verified StoreKit app history, and app-container creation time. The SDK
sends these values only during install resolution. User match data is sent only
when your app passes it explicitly.

Pending events are stored as individually encrypted records. Raw email, phone,
name, date-of-birth, external-ID, and customer-user-ID values are retained for
at most 24 hours; after that they are redacted while non-identity delivery data
may remain for at most seven days. Delivered records are deleted immediately.
The encrypted queue is capped at 100 records and 1 MiB, dropping oldest first.
Temporary Keychain unavailability preserves encrypted records for a later retry;
only malformed or authentication-failed ciphertext is discarded.

The package includes `PrivacyInfo.xcprivacy` declarations for SDK install/user
identifiers, event interaction data, Apple Ads signals, and optional user match
fields. Review Xcode's merged privacy report and your App
Store Connect privacy answers for the Adback features your app enables.

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
