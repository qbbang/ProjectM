import ProjectDescription

let project = Project(
    name: "Component",
    targets: [
        Target.target(
            name: "Component",
            destinations: [.iPhone],
            product: .framework,
            bundleId: "com.jokerLee.Component",
            deploymentTargets: .iOS("15.0"),
            sources: ["Sources/**"],
            dependencies: []
        )
    ],
    additionalFiles: [
        "Sources/Empty.swift"
    ]
)
