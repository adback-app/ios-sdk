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

In `0.1.1`, `configure` stores local SDK configuration for the app process. The
networked configure slice will fetch remote SDK config, including:

- `sdk_enabled` and remote kill-switch state.
- SDK endpoint paths.
- Event queue limits and retry defaults.
- Debug mode defaults.
- Privacy gates such as optional IDFV collection.

## Event Boundary

MVP SDK events are for install and funnel signals such as signup, checkout
intent, trial start, and custom debug/funnel events. The `0.1.1` binary includes
the v1 event/config model surface; background event delivery is planned after
the configure/queue slice. SDK event payloads use `schema_version: 1` and
snake_case wire fields.

Do not send purchase/subscription revenue through the mobile SDK. Revenue truth
comes from RevenueCat, Superwall, App Store Server Notifications, or customer
backend webhook/API events.

## Debugging

Debug mode may log event IDs, install IDs, Adback IDs, rejection codes, and
`match_trace_id`. It must not log SDK keys, ASA tokens, raw user match data,
StoreKit payloads, provider credentials, or backend-only
`install_match_signature`.
