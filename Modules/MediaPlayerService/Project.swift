import ProjectDescription

let project = Project(
    name: "MediaPlayerService",
    targets: [
        Target.target(
            name: "MediaPlayerService",
            destinations: [.iPhone],
            product: .framework,
            bundleId: "com.jokerLee.MediaPlayerService",
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
