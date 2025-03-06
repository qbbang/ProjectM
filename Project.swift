
import ProjectDescription

extension SettingValue {
    static let marketingVersion: SettingValue = "0.0.0"
    static let projectVersion: SettingValue = "0"
}

let project = Project(
    name: "MusicPlayer",
    targets: [
        Target.target(
            name: "MusicPlayer",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.jokerLee.MusicPlayer",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
                    "UIBackgroundModes": ["audio"],
                    "NSAppleMusicUsageDescription": "음악 라이브러리에서 콘텐츠를 가져오려면 권한이 필요합니다."
                ]
            ),
            sources: ["Projects/MusicPlayer/Sources/**"],
            dependencies: [
                .project(target: "AudioService", path: .relativeToRoot("Modules/AudioService")),
                .project(target: "Component",    path: .relativeToRoot("Modules/Component")),
                .project(target: "MiniPlayer",   path: .relativeToRoot("Modules/MiniPlayer"))
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "6.0",
                    "CURRENT_PROJECT_VERSION": .projectVersion,
                    "MARKETING_VERSION": .marketingVersion,
                    "CODE_SIGN_STYLE": "Automatic",
                ],
                configurations: [
                    .debug(name: .debug),
                    .release(name: .release)
                ],
                defaultSettings: .recommended
            )
        )
    ]
)
