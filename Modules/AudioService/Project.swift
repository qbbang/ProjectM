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
        ),
        Target.target(
            name: "AudioServiceTests",
            destinations: [.iPhone],
            product: .unitTests,
            bundleId: "com.jokerLee.AudioServiceTests",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [.target(name: "AudioService")]
        )
    ],
    additionalFiles: [
        "Sources/Empty.swift"
    ]
)
