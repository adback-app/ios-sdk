# Adback iOS SDK

Adback attributes app installs and subscription revenue back to paid campaigns.

## Install

In Xcode, add this package URL:

```text
https://github.com/adback-app/ios-sdk
```

## Quickstart

```swift
import AdbackSDK

Adback.configure(apiKey: "adbk_pk_live_...")
```

The SDK uses `https://api.adback.app` for:

```text
GET  /v1/sdk/config
POST /v1/sdk/installs/resolve
POST /v1/sdk/events
```

`adback.link` is used for tracking links and redirects only. The SDK does not
call `adback.link`.

## RevenueCat and Superwall

Use Adback attribution params with RevenueCat, Superwall, or your own paywall
targeting. Send actual purchase/subscription revenue through RevenueCat,
Superwall, App Store Server Notifications, or your backend webhook/API
integration.

The mobile SDK does not expose SDK-side purchase, subscription, StoreKit capture,
manual revenue, transaction, or `transaction_details` APIs for the MVP.

## Privacy

The SDK does not collect IDFA by default, precise location, contacts, photos,
clipboard contents, or installed-app lists. IDFV may be collected on iOS as an
optional app/environment-gated install/debug/match signal. User match data is
only sent when the app developer passes it explicitly.

## Support

Dashboard: https://console.adback.app
