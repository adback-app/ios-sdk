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

In `0.1.3`, `configure` starts SDK bootstrap in the background. It fetches the
lean remote SDK config: `app_id`, `sdk_enabled`, `use_install_detection_v2`,
`values`, and `lockWindows`.

After config succeeds, the SDK resolves the install with
`POST /v1/sdk/installs/resolve`. The install resolve request includes
Adback install-match headers for SDK version, app/build, OS, device model,
timezone, locale, screen dimensions, and install ID. The SDK then sends an
automatic `INSTALL` SDK event with `POST /v1/sdk/events`.

Call `flush` when you need to wait for pending SDK delivery in debug builds or
tests:

```swift
await Adback.flush()
```

## Event Boundary

MVP SDK events are for install and funnel signals such as signup, checkout
intent, trial start, and custom debug/funnel events. `0.1.3` sends automatic
install activity and exposes manual standard event tracking:

```swift
Adback.track(.signUp)
Adback.track(.startTrial, properties: ["plan": .string("annual")])
```

SDK event payloads use `schema_version: 1` and snake_case wire fields.

Do not send purchase/subscription revenue through the mobile SDK. Revenue truth
comes from RevenueCat, Superwall, App Store Server Notifications, or customer
backend webhook/API events.

## Debugging

Debug mode may log event IDs, install IDs, Adback IDs, rejection codes, and
`match_trace_id`. It must not log SDK keys, ASA tokens, raw user match data,
StoreKit payloads, provider credentials, or backend-only
`install_match_signature`.
