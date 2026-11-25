import Foundation
import LiveLocation

// usage: age-rating-check <capabilities.json> <age-rating.json>
// Exit 0: code and declaration agree (warnings printed). Exit 1: blocking drift. Exit 2: bad input.
let args = CommandLine.arguments
guard args.count == 3 else {
    FileHandle.standardError.write(Data("usage: age-rating-check <capabilities.json> <age-rating.json>\n".utf8))
    exit(2)
}
do {
    let manifest = try CapabilityManifest.decode(Data(contentsOf: URL(fileURLWithPath: args[1])))
    let declaration = try AgeRatingDeclaration.decode(Data(contentsOf: URL(fileURLWithPath: args[2])))
    let drift = AgeRatingGate.check(manifest: manifest, declaration: declaration)
    for d in drift { print("\(d.isBlocking ? "error" : "warning"): \(d.message)") }
    if drift.contains(where: \.isBlocking) { exit(1) }
    print("ok: Shared Location = \(declaration.sharedLocation ? "Yes" : "No") matches the capability manifest")
} catch {
    FileHandle.standardError.write(Data("error: \(error)\n".utf8))
    exit(2)
}
