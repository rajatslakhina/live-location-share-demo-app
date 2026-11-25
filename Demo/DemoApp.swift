import SwiftUI
import LiveLocation
import LiveLocationUI

/// The app's capability manifest and its exported App Store Connect age-rating answer, bundled from
/// `Demo/Config`. The same two files are what CI checks with `AgeRatingGate` (`Tools/AgeRatingCheck`),
/// and `SharerSession` refuses to start without `liveLocationSharing` in the manifest — so the code path
/// and the "Shared Location" answer come from one place.
enum AppConfig {
    static func manifest(bundle: Bundle = .main) -> CapabilityManifest {
        // A missing or malformed manifest must fail closed: no capability, so the session refuses to share.
        guard let url = bundle.url(forResource: "capabilities", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let manifest = try? CapabilityManifest.decode(data) else { return CapabilityManifest(capabilities: []) }
        return manifest
    }

    static func declaration(bundle: Bundle = .main) -> AgeRatingDeclaration {
        guard let url = bundle.url(forResource: "age-rating", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let declaration = try? AgeRatingDeclaration.decode(data) else { return AgeRatingDeclaration(sharedLocation: false) }
        return declaration
    }
}

@main
struct LiveLocationDemoApp: App {
    /// Launch with `-tab sharer|timeline|viewers|capacity|gate` to open a specific tab (used for screenshots).
    private let initialTab: LiveShareDemoView.Tab = {
        let args = ProcessInfo.processInfo.arguments
        guard let i = args.firstIndex(of: "-tab"), args.indices.contains(i + 1),
              let tab = LiveShareDemoView.Tab(rawValue: args[i + 1]) else { return .sharer }
        return tab
    }()

    var body: some Scene {
        WindowGroup {
            LiveShareDemoView(manifest: AppConfig.manifest(), declaration: AppConfig.declaration(), initialTab: initialTab)
        }
    }
}
