# Adback iOS SDK Privacy Notes

MVP commitments:

- No IDFA collection by default.
- No precise location, contacts, photos, clipboard contents, or installed-app
  list collection.
- Optional IDFV collection only when enabled by app/environment config as an iOS
  install/debug/match signal.
- User match data is sent only when the app developer passes it explicitly.
- ASA tokens are sent only on the install resolve / Apple Ads attribution path,
  never as normal event metadata.
- SDK purchase/subscription revenue, StoreKit capture, transactions, and
  `transaction_details` are out of MVP.

`PrivacyInfo.xcprivacy` declares the SDK's app-local `UserDefaults` state under
Apple's `NSPrivacyAccessedAPICategoryUserDefaults` required-reason API category.
