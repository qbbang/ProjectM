
# ProjectM

SwiftUI 기반 iOS 음악 플레이어

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


## ⚠️ 추가로 고려해야하는 사항
- 녹음 아이콘 노출이 있으나 기능에 대한 기능 명세가 존재하지 않음
- 미니 플레이어의 초기값에 대한 정의가 없음
- 임의 재생에 대한 정의가 부족함


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
