
import ProjectDescription

extension SettingValue {
    static let marketingVersion: SettingValue = "1.0.0"
    static let projectVersion: SettingValue = "0"
}

let plist: [String : Plist.Value] = [
    "UILaunchScreen": [
        "UIImageName": "LaunchImage",
        "UIImageRespectsSafeAreaInsets": true
    ],
    "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
    "UIUserInterfaceStyle": "Light",
    "UIBackgroundModes": ["audio"],
    "NSAppleMusicUsageDescription": "음악 라이브러리에서 콘텐츠를 가져오려면 권한이 필요합니다.",
    "CFBundleShortVersionString": "$(MARKETING_VERSION)",
    "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)"
]

let project = Project(
    name: "MusicPlayer",
    targets: [
        Target.target(
            name: "MusicPlayer",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.jokerLee.MusicPlayer",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(with: plist),
            sources: ["Projects/MusicPlayer/Sources/**"],
            resources: ["Projects/MusicPlayer/Resources/**"],
            dependencies: [
                .project(target: "MediaPlayerService", path: .relativeToRoot("Modules/MediaPlayerService")),
                .project(target: "MiniPlayer",   path: .relativeToRoot("Modules/MiniPlayer"))
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "6.0",
                    "CURRENT_PROJECT_VERSION": .projectVersion,
                    "MARKETING_VERSION": .marketingVersion,
                    "CODE_SIGN_STYLE": "Automatic",
                    "DEVELOPMENT_TEAM": "9DL55EF8D3"
                ],
                configurations: [
                    .debug(name: .debug),
                    .release(name: .release)
                ],
                defaultSettings: .recommended
            )
        ),
        Target.target(
            name: "MusicPlayerTests",
            destinations: [.iPhone],
            product: .unitTests,
            bundleId: "com.jokerLee.MusicPlayerTests",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(with: plist),
            sources: ["Projects/MusicPlayerTests/Sources/**"],
            dependencies: [
                .target(name: "MusicPlayer"),
                .project(target: "MediaPlayerService", path: .relativeToRoot("Modules/MediaPlayerService")),
                .project(target: "MiniPlayer",   path: .relativeToRoot("Modules/MiniPlayer"))
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "6.0",
                    "CURRENT_PROJECT_VERSION": .projectVersion,
                    "MARKETING_VERSION": .marketingVersion,
                    "CODE_SIGN_STYLE": "Automatic",
                    "DEVELOPMENT_TEAM": "9DL55EF8D3",
                    "ENABLE_TESTABILITY": "YES"
                ],
                configurations: [
                    .debug(name: .debug),
                    .release(name: .release)
                ],
                defaultSettings: .recommended
            )
        )
    ],
    schemes: [
        Scheme.scheme(
            name: "MusicPlayer-Debug",
            buildAction: .buildAction(targets: ["MusicPlayer"]),
            runAction: .runAction(
                arguments: .arguments(
                    environmentVariables: [
                        // https://developer.apple.com/documentation/xcode/validating-your-apps-metal-api-usage
                        "MTL_DEBUG_LAYER": "0"
                    ]
                )
            )
        )
    ]
)
