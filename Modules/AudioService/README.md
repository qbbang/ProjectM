
# AudioService

##
 

## 개발노트

[MediaPlayer](https://developer.apple.com/documentation/mediaplayer)
- 음악 라이브러리에 접근하여 [MPMediaQuery](https://developer.apple.com/documentation/mediaplayer/mpmediaquery)로 미디어셋를 가져올 수 있음
    - 앨범, 노래, 아티스트 등등
- 별도의 데이터 타입이 있기 때문에 [MPMusicPlayerController](https://developer.apple.com/documentation/mediaplayer/mpmusicplayercontroller)로 제어해야함
    
```
(lldb) po query
<MPMediaQuery:0x300058d80 [<MPMediaLibrary: 0x10198fe80> uniqueID=EE7EA2EC-A402-4579-AF38-04177FAFF172 [<ICUserIdentity 0x3000a3b10: [Active Account: <unresolved>]>] dataProvider: 0x303c23f00] MPMediaGroupingTitle, {(
    <MPMediaPropertyPredicate 0x300e798a0> 'mediaType' equal to '2049' music | musicVideo
)}, SystemFilters=enabled>

(lldb) po items
▿ 6 elements
  - 0 : <MPConcreteMediaItem: 0x301ba0a80> 3094018958437810662
  - 1 : <MPConcreteMediaItem: 0x301ba0b80> 3094018958437810665
  - 2 : <MPConcreteMediaItem: 0x301ba0c40> 3094018958437810667
  - 3 : <MPConcreteMediaItem: 0x301ba0d00> 3094018958437810663
  - 4 : <MPConcreteMediaItem: 0x301ba0dc0> 3094018958437810666
  - 5 : <MPConcreteMediaItem: 0x301ba0e80> 3094018958437810664
```
-

[AVFoundation](https://developer.apple.com/documentation/avfoundation)
- 로컬 음악 파일 및 원격 url 스트리밍으로 재생 가능
 

