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

Since `0.2.0`, `configure` starts SDK bootstrap in the background. It fetches the
lean remote SDK config: `app_id`, `sdk_enabled`, `use_install_detection_v2`,
`values`, `lockWindows`, and optional `attribution_retry`.

After config succeeds, the SDK resolves the install with
`POST /v1/sdk/installs/resolve`, then sends an automatic `INSTALL` SDK event
with `POST /v1/sdk/events`.

Version `0.3.0` supports optional install `resolution` responses. The SDK
retries `unmatched_settling` results while active and after foreground events.
It stops after `matched` or `final_unattributed`.

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

Apple Ads resolution can complete after the initial handoff. Register an update
handler before configuration to receive best-known and changed values, and use
the explicit refresh when the host integration needs an immediate status check:

```swift
Adback.setAttributionUpdateHandler { attributes in
  // The callback is asynchronous and is not guaranteed to run on MainActor.
  Purchases.shared.setAttributes(attributes)
}

let latest = await Adback.refreshAttribution()
```

After an Apple Ads token is queued, the SDK performs a bounded cancellable
background refresh. Polls contain a token-present signal but never resend the
raw token. Reconfigure/reset guards discard stale results.

## Reset

`Adback.reset()` clears SDK configuration, attribution, and queued events. It
preserves the install identity and immutable first-open time. A later
configuration continues the same installation.

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
The automatic `INSTALL` is in the same durable retry queue, and concurrent
track/flush work is serialized so one stable event produces one network post at
a time.

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

Local queue payloads are individually AES-GCM encrypted with a random 256-bit
key held in the app Keychain. Raw customer match fields are redacted after 24
hours; non-identity delivery records expire after seven days. Delivered records
are deleted, and the queue drops oldest first above 100 records or 1 MiB of
ciphertext. Maintenance diagnostics contain only reason/count/byte totals.
Temporary Keychain unavailability preserves ciphertext and queue metadata for a
later retry; only malformed or authentication-failed records are discarded.
