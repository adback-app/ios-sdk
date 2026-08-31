# Adback iOS SDK Privacy Notes

MVP commitments:

- No IDFA collection by default.
- No precise location, contacts, photos, clipboard contents, or installed-app
  list collection.
- The SDK collects IDFV and IDFV-change evidence for reinstall attribution.
- The SDK creates device-only and synchronizable Keychain reinstall UUIDs.
- The SDK reads verified StoreKit app-transaction history for reinstall attribution.
- The SDK reads app-container creation time for reinstall attribution.
- The SDK sends these values only during install resolution and never logs them.
- User match data is sent only when the app developer passes it explicitly.
- ASA tokens are sent only on the install resolve / Apple Ads attribution path,
  never as normal event metadata.
- SDK purchase/subscription revenue, StoreKit transaction capture, and
  `transaction_details` remain out of MVP.
- Optional 0.3.0 diagnostics capture only a coarse one-shot network-path
  classification (interface class plus IPv4/IPv6/constrained/expensive
  booleans) and metadata-only signal-family presence bits. No SSID, BSSID,
  carrier name, radio technology, local/public IP, VPN application identity, or
  continuous network history is collected, and no raw signal values are logged.

`PrivacyInfo.xcprivacy` declares the SDK's app-container creation-time access
under Apple's `NSPrivacyAccessedAPICategoryFileTimestamp` category with reason
`C617.1`. It also declares app-local `UserDefaults` state under the
`NSPrivacyAccessedAPICategoryUserDefaults` required-reason API category.
