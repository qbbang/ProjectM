import ProjectDescription

let project = Project(
    name: "MiniPlayer",
    targets: [
        Target.target(
            name: "MiniPlayer",
            destinations: [.iPhone],
            product: .framework,
            bundleId: "com.jokerLee.MiniPlayer",
            deploymentTargets: .iOS("15.0"),
            sources: ["Sources/**"],
            dependencies: []
        )
    ],
    additionalFiles: [
        "Sources/Empty.swift"
    ]
)

