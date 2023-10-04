# Weather_Fairy

## 🧑‍🤝‍🧑 Team Members (구성원)
<table>
  <tbody>
    <tr>
     <td align="center" valign="top" width="14.28%">
       <a href="https://github.com/Luna828">
       <img src="https://avatars.githubusercontent.com/u/93186591?v=4" width="100px;" alt="김은경"/>
       <br />
         <sub>
           <b>김은경</b>
         </sub>
       </a>
       <br />
       <sub>
           <b>iOS Developer</b>
       </sub>
       <br />
     </td>
    <td align="center" valign="top" width="14.28%">
       <a href="https://github.com/angwoo0503">
       <img src="https://avatars.githubusercontent.com/u/136118540?v=4" width="100px;" alt="최진훈"/>
       <br />
         <sub>
           <b>박상우</b>
         </sub>
       </a>
       <br />
       <sub>
           <b>iOS Developer</b>
       </sub>
       <br />
     </td>
      <td align="center" valign="top" width="14.28%">
       <a href="https://github.com/chumubird">
       <img src="https://avatars.githubusercontent.com/u/138557882?v=4" width="100px;" alt="서준영"/>
       <br />
         <sub>
           <b>박철우</b>
         </sub>
       </a>
       <br />
       <sub>
           <b>iOS Developer</b>
       </sub>
       <br />
     </td>
      <td align="center" valign="top" width="14.28%">
       <a href="https://github.com/dnjs012452">
       <img src="https://avatars.githubusercontent.com/u/139090550?v=4" width="100px;" alt="한지욱"/>
       <br />
         <sub>
           <b>원성준</b>
         </sub>
       </a>
       <br />
       <sub>
           <b>iOS Developer</b>
       </sub>
       <br />
     </td>
  </tbody>
</table>

## 🖥️ TEAM APP Project - Weather_Fairy
> 스파르타코딩 iOS_7기 iOS심화 팀프로젝트 `떡잎마을 방범대` 입니다
> 
> 저희 팀은 이번 3가지 주제중 4명에게 부족한 API 공부를 위하여 `날씨 App`을 진행하기로 하였습니다.
> 
> **앱 구성 : 보라색 하이라이트 → 기능 핵심**
> 
> - UI를 구성하는 Item들을 `모듈화`시켜 하나의 MainWeatherView에 옮김
>     
>     → VC에서 `loadView`에 `view = mainWeatherView` 로 view를 씌워주기
>     
> - 검색 기록을 저장하기 위한 수단 = `UserDefault` 사용
> - 가져와야할 api 정보
>     - 현재기온
>     - 최고/최저 기온
>     - 지역 이름
>     - 대기질
>     - 바람
>     - 습도
>     - 강수확률
> - 강수확률에 따른 준비물 `알림`기능 추가
> - `MapKit` 라이브러리 사용하여 현재 위치 보이기
> 
> 개발기간: 2023/09/25 월요일 ~ 2023/10/05 목요일
> 
> 발표: 2023/10/06 금요일
>

## 👨‍💻 역할분담 및 프로젝트 주요기능 
* [TEAM S.A](https://www.notion.so/S-A-1f9f48c90f2b49b6a6a4a3e2cda18086)

* 김은경
  > 작성
  
* 박상우
  > 작성
  
* 박철우
  > 작성
  
* 원성준
  > 작성

## ⚡️ 팀 규칙
```text
1. 아래의 Git Convention 지켜서 commit과 PR 요청하기! 
git commit -m "[FEAT] : ⚙️ commit init"

2. 스크럼: 오전 9시 30분
3. Pull Request: 오후 8시

4. 자리비울 때 말하기 (개인사정)
5. 이슈 트랙킹/트러블슈팅시 질문하기
```
## ⚙️ Requirements

- 최소 iOS 14.0 +

- Xcode 14.3.1

- 필수 구현 기능(필수)
    - [x]  사용자 위치 지정
    - [x]  날씨 데이터
    - [x]  사용자 입력 (SearchPage 검색창)
    - [x]  날씨 표시
    - [x]  단위 변환
    - [x]  사용자 친화적인 인터페이스
    - [x]  데이터 새로 고침
    - [x]  배경 이미지
    
- 추가 구현 기능(선택)
    - [x]  알림
    - [x]  예보 (3시간별, 5일간)
    - [x]  위치 서비스
    - [x]  지도 통합
    - [x]  검색 기록
    - [ ]  애니메이션
    - [x]  디자인 패턴 (MVVM)
    
- **GIT**
    - [x]  git add / commit / push 활용
    - [x]  git 브랜치/ PR / merge 활용
    - [ ]  github pull request에서 Code review 활용

## ✏️ 와이어프레임
  <table>
    <tr>
      <td>
        <img src="https://github.com/iOS-Oppenheimer/Weather_Fairy/assets/93186591/d61440c8-6d28-4f95-8ff8-d12b6406dd37"/>
      </td>
      <td>
        <img src="https://github.com/iOS-Oppenheimer/Weather_Fairy/assets/93186591/b90a5003-4326-4904-9c44-e3efda574e67"/>
      </td>
      <td>
        <img src="https://github.com/iOS-Oppenheimer/Weather_Fairy/assets/93186591/5af549eb-ff7a-4afd-9eb6-5fc073411814"/>
      </td>
    </tr>
  </table>

  <table>
    <tr>
      <td>
        <img src="https://github.com/iOS-Oppenheimer/Weather_Fairy/assets/93186591/b112fa1e-10ca-4612-a115-2933f56bcaae"/>
      </td>
    </tr>
  </table>

## ⭐️ YOUTUBE 시연영상 ⭐️


## 📚 Library
```text
//외부 라이브러리
https://github.com/SnapKit/SnapKit

//내부 라이브러리
import UserNotifications
import MapKit
```

## 🔥 Project Issue 🔥
```text

```

## 🍎 회고 & 느낀점
```text

```
