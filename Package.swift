import PackageDescription

let package = Package(
    name: "LinkMark",
    dependencies: [
        .Package(url: "https://github.com/shjborage/CommandLine.git", Version(3, 0, 0, prereleaseIdentifiers: ["pre1"]))
    ]
)
