# Adback iOS SDK Usage

## Configure

```swift
import AdbackSDK

Adback.configure(
  apiKey: "adbk_pk_live_...",
  options: .init(
    environment: .production,
    apiBaseURL: URL(string: "https://api.adback.app")!,
    debug: false
  )
)
```

In `0.1.10`, `configure` starts SDK bootstrap in the background. It fetches the
lean remote SDK config: `app_id`, `sdk_enabled`, `use_install_detection_v2`,
`values`, and `lockWindows`.

After config succeeds, the SDK resolves the install with
`POST /v1/sdk/installs/resolve`, then sends an automatic `INSTALL` SDK event
with `POST /v1/sdk/events`.

To enable Apple Ads attribution on iOS 14.3+, call:

```swift
Adback.enableAppleAdsAttribution()
```

This does not request App Tracking Transparency permission.

Call `flush` when you need to wait for pending SDK delivery in debug builds or
tests:

```swift
await Adback.flush()
```

## Attribution Handoff

Use the resolved Adback attributes with Superwall, RevenueCat, or your backend:

```swift
if let attributes = await Adback.getAttributionParams() {
  Purchases.shared.setAttributes(attributes)

  let superwallAttributes: [String: Any?] = attributes.mapValues { $0 }
  Superwall.shared.setUserAttributes(superwallAttributes)
}

let adbackId = Adback.getAdbackId()
```

`getAttributionParams()` waits for initial bootstrap if it is still running.
`getAdbackId()` is synchronous and returns `nil` until install resolve has
completed.

## Event Boundary

MVP SDK events are for install and funnel signals such as signup, checkout
intent, trial start, and custom debug/funnel events. The SDK sends automatic
install activity and exposes manual standard and custom event tracking:

```swift
Adback.track(.signUp)
Adback.track(.startTrial, properties: ["plan": .string("annual")])
Adback.track("paywall_viewed", properties: ["surface": .string("onboarding")])
```

`INSTALL` is reserved for automatic SDK delivery. `Adback.track(.install)` is
ignored so the app cannot send a duplicate install event.
Manual events are queued locally and retried by `flush`, future `track` calls,
and the next successful configuration.

SDK event payloads use `schema_version: 1` and snake_case wire fields.
React Native and Flutter wrappers add wrapper name/version metadata to the SDK
context so backend debugging can distinguish wrapped SDK traffic.

Do not send purchase/subscription revenue through the mobile SDK. Revenue truth
comes from RevenueCat, Superwall, App Store Server Notifications, or customer
backend webhook/API events.

## Debugging

Debug mode emits redacted diagnostics only. It may include safe categories such
as HTTP status or decoding failure, but it must not log SDK keys, ASA tokens,
raw user match data, StoreKit payloads, provider credentials, or backend-only
`install_match_signature`.
