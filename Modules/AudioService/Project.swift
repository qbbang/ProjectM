import ProjectDescription

let project = Project(
    name: "AudioService",
    targets: [
        Target.target(
            name: "AudioService",
            destinations: [.iPhone],
            product: .framework,
            bundleId: "com.jokerLee.AudioService",
            deploymentTargets: .iOS("15.0"),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: []
        )
    ],
    additionalFiles: [
        "Sources/Empty.swift"
    ]
)
