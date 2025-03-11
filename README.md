
# ProjectM

SwiftUI 기반 iOS 음악 플레이어

ProjectM은 SwiftUI를 기반으로 개발된 iOS 음악 플레이어 애플리케이션 
최신 iOS 기술 스택을 활용하여 안정적이고 직관적인 사용자 경험을 제공하며,
모듈화된 아키텍처와 동시성 처리를 통해 유지보수성과 확장성을 높였습니다.
 
 프로젝트는 음악 재생, 앨범 관리, 미니 플레이어 컨트롤 기능을 제공하며, 
시스템 음악 앱과의 완벽한 호환성을 목표로 개발하였습니다.

## 기술 스택

- SwiftUI: 선언적 UI 프레임워크를 활용하여 직관적이고 유연한 UI 구현.
- Combine: 비동기 데이터 스트림 처리 및 노티피케이션 구독 관리.
- Swift 6 동시성(async/await): 동시성 처리를 통해 안정적이고 효율적인 비동기 작업 지원.
- MV Architecture: 뷰와 비즈니스 로직을 명확히 분리하여 테스트와 유지보수 용이성 확보.
- Tuist: 프로젝트 관리 도구를 사용하여 모듈화된 구조를 효율적으로 관리.

|    |   |
|----------|----------|
|          | ![image](https://github.com/user-attachments/assets/f53672fa-e929-42d6-93eb-f093fdcf10a2) |



## 빌드 방법

git clone https://github.com/qbbang/ProjectM.git
./init.sh

```
/init.sh
==> Tuist uninstalled
Warning: tuist/tuist/tuist@4.43.2 4.43.2 is already installed and up-to-date.
To reinstall 4.43.2, run:
  brew reinstall tuist@4.43.2
Successfully cleaned artifacts at path /Users/mk-am16-009/.cache/tuist/Plugins
Successfully cleaned artifacts at path /Users/mk-am16-009/.cache/tuist/Projects
Successfully cleaned artifacts at path /Users/mk-am16-009/.cache/tuist/ProjectDescriptionHelpers
Successfully cleaned artifacts at path /Users/mk-am16-009/.cache/tuist/Manifests
Successfully cleaned artifacts at path /Users/mk-am16-009/.cache/tuist/EditProjects
Successfully cleaned artifacts at path /Users/mk-am16-009/.cache/tuist/Runs
Successfully cleaned artifacts at path /Users/mk-am16-009/.cache/tuist/Binaries
Successfully cleaned artifacts at path /Users/mk-am16-009/.cache/tuist/SelectiveTests
There's nothing to clean for dependencies
Resolving and fetching plugins.
Plugins resolved and fetched successfully.
Loading and constructing the graph
It might take a while if the cache is empty
Using cache binaries for the following targets:
Generating workspace MusicPlayer.xcworkspace
Generating project MiniPlayer
Generating project MediaPlayerService
Generating project MusicPlayer
Project generated.
```

|    |   |    |   |
|----|----|----|----|
| ![IMG_7414](https://github.com/user-attachments/assets/9bac76cd-b9af-477a-b7f4-63ac97f40dc5) | ![IMG_7415](https://github.com/user-attachments/assets/d90dca9a-4798-4134-9417-5c0972bfba70) | ![image](https://github.com/user-attachments/assets/eaeaa05e-e6b2-4c96-a082-04086a88ee8d) | ![image](https://github.com/user-attachments/assets/a9460131-f571-47e2-b583-3a3359ac0b5a)|



## 기능 검증

### 루트 화면 기능 및 테스트 케이스

- 런치스크린이 노출된다.
- 미디어 권한 관련 시스템 알럿을 노출한다.
    - [x]  시스템 알럿이 정상적으로 노출되는가
    - 허용 시 앨범 리스트 화면이 노출한다.
        - [x]  앨범 리스트 화면이 노출되는가?
    - 허용 안함 시
        - 권한 설정 가이드 화면을 노출한다
            - [x]  가이드 화면을 노출하는가
            - [x]  가이드 화면의 설을 버튼을 통해 설정 → 앱으로 이동하는가?
            - [x]  권한 허용 및 포그라운드 전환 시 앨범 리스트가 노출되는가?
            - [x]  권한 제거 및 포그라운드 전환 시 가이드 화면이 노출되는가?

### 앨범 리스트 / 앨범 상세 화면 기능 및 테스트 케이스

- 앨범 리스트 화면에서 미니플레이어가 노출된다.
- 미니플레이어는 현재 재생되는 곡의 상태를 가진다.
- 각 앨범에 진입, 앨범 상세 화면에서 곡 목록을 확인할 수 있다
- 요구 조건였지만 마이크 버튼은 기능정의가 없음으로 제거한다.
- 앨범 상세에서 아래 기능을 제공한다
    - 앨범 이미지 / 노래 제목 / 가수 정보를 제공한다
    - 재생/정지, 임의재생 기능을 제공한다
        - [x]  재생/정지가 되는가?
        - [x]  임의 재생이 되는가?
        - [x]  임의 재생 시 현재곡이 하이라이트 되는가?
- 곡목록에서 선택재생을 제공한다
    - [x]  선택 재생 시 재생이 되는가?
    - [x]  선택 시 하이라이트가 처리되는가
- 모든 기능은 미니플레이어와 동기화 된다.
    - 미니플레이어가 같은 앨범을 재생 시 앨범 상세 기능에서
    - [x]  재생/정지 버튼의 싱크가 맞는가?
    - [x]  현재 곡이 곡 목록에서 하이라이트 되어 있는가?
    - [x]  임의재생이 잘 작동하는가
        - 미니 플레이어에서
        - [x]  재생/정지 버튼의 싱크가 맞는가?
    - 미니플레이어가 다른 앨범을 재생 시 앨범 상세 기능에서
        - [x]  재생 시 해당 앨범으로 변경되는가
        - [x]  선택 재생 시 해당 앨범으로 변경되는가
        - [x]  재생/정지 버튼의 싱크가 맞는가?
        - [x]  곡 목록에서 하이라이트가 안되어 있는가?
        - [x]  임의 재생이 잘 동작하는가? (해당 화면은 변경되지 않는다)
        - 미니 플레이어에서
            - [x]  재생/정지 버튼의 싱크가 맞는가? (해당 화면은 변경되지 않는다)
        
### 미니플레이어 상세화면 기능 및 테스트 케이스
`음악 앱과 동일한 기능을 제공한다`

- 반복 모드를 제공한다
    - [x]  none → all → one 으로  모드가 변경되는가
    - [x]  시스템 앱과 상호 동기화가 되는가?
    - [x]  각 모드 별로 앨범 내 반복모드가 작동하는가?
- 이전 곡 / 다음 곡 재생을 제공한다
    - [x]  이전 / 다음 곡으로 이동하는가
    - [x]  앨범 개수를 초과하는 다음 곡인 경우 재생이 멈추는가? (시스템앱과 동일 동작)
- 재생/정지를 제공한다
    - [x]  시스템 앱과 앨범 상세화면과 상호 동기화가 되는가?
- 임의 재생을 제공한다
    - [x]  시스템 앱과 앨범 상세화면과 상호 동기화가 되는가?
- 재생 위치 조정을 슬라이드로 제공한다
    - [x]  슬라이드로 재생 위치를 조정할 수 있는가?
    - [x]  재생이 끝나고 업데이트가 정상적으로 이루어 지는가?
- 시스템 음향 조정을 슬라이드로 제공한다
    - [x]  슬라이드로 시스템음향을 조정할 수 있는가?
    - [x]  시스템 볼륨 조절 인디게이터가 노출되는가?


-----------








# 초기 설계 히스토리

## 기능 정의

- 앱 초기화면 Navigation은 Large Navigation로 표현된다
    - 우측 네비게이션아이템에 녹음 아이콘이 노출한다.
        - ⚠️ 해당 기능에 대한 명세서가 없음
    
- 앱의 초기화면에서 앨범 목록이 노출된다.
    - 각 앨범은 앨범아트, 앨범 제목, 아티스트가 표시된다.
    
- 앱의 하단에는 미니 플레이어가 노출된다.
    - 미니 플레이어는 현재 음악의 재생상태를 반영한다.
    - ⚠️ 초기값은 디테일한 요구사항이 없음으로 두가지 안이 존재 UX 고민하고 처리할 것
        - 1안) 재생 중이 아님을 표기하고 항상 미니플레이어를 노출한다
        - 2안) 재생 중인 경우에만 노출한다.
        - 3안) 재생 중이 아님을 표기하고 알파를 조정, 노출 위치를 학습 시키고 재생 시 강조 노출한다.
        
- 앨범 목록에서 앨범 화면으로 진입할 수 있다.
    - 앨범 화면에는 해당 앨범의 곡 목록이 노출된다.
    - 재생 버튼을 누르면 1번 곡부터 차례대로 재생된다.
    - 곡 목록에서 곡을 누르면 해당 곡부터 차례대로 재생된다.
    - 임의 재생 버튼을 누르면 앨범의 곡 전체가 임의로 재생된다.
        - ⚠️ 임의 재생에 대한 정의가 부족함.
    - 하단에 미니 플레이어가 노출된다.
    
- 미니 플레이어를 누르면 Modality하게 콘텐츠를 제공해야한다.
    - 재생/일시정지, 뒤로감기, 빨리 감시, 셔플, 반복, 볼륨 컨트롤, 재생 컨트롤 기능을 제공해야한다.
    
- 백그라운드에서도 재생 및 컨트롤이 가능해야한다.
    - BackgroundModes

## 개발환경

### 기술 스택

- MV Architecture, SwiftUI, Combine, async-await, 
- 프로젝트 관리 tuist
    - 구조 
    
```
ProjectM
ㄴ Application
    ㄴ Project.swift
    ㄴ Sources
        ㄴ MusicPlayer
ㄴ Modules
    ㄴ Components
    ㄴ AudioService
    ㄴ MiniPlayer
```


### 커밋메시지
feat: → 새로운 기능을 추가할 때 사용합니다.

fix: → 발견된 버그를 수정하거나, 개발자가 문제를 찾아 수정할 때 사용합니다.

env: → 개발 환경 설정을 변경하거나 업데이트할 때 사용합니다.

docs: → 문서를 작성할때 사용합니다.

refactor: → 기능의 변화 없이 코드 구조를 개선할 때 사용합니다.
