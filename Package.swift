// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "AdbackSDK",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(
      name: "AdbackSDK",
      targets: ["AdbackSDK"]
    )
  ],
  targets: [
    .binaryTarget(
      name: "AdbackSDK",
      path: "./AdbackSDK.xcframework"
    )
  ]
)
