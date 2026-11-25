// swift-tools-version: 6.0
// CI tool for this demo repo (not part of the app): checks the bundled capability manifest against the
// exported App Store Connect age-rating answer, using the library's own AgeRatingGate.
import PackageDescription

let package = Package(
    name: "AgeRatingCheck",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/rajatslakhina/live-location-share-kit.git", exact: "2.1.5"),
    ],
    targets: [
        .executableTarget(name: "age-rating-check",
                          dependencies: [.product(name: "LiveLocation", package: "live-location-share-kit")]),
    ]
)
