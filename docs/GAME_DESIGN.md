# Infinite Stairs PC - Game Design Document

## 1. Overview

**Title**: Infinite Stairs PC
**Genre**: 2D Arcade / Endless Runner
**Platform**: PC (Windows, Linux, macOS)
**Engine**: Godot 4.x
**Input**: Keyboard (2 keys)

### 1.1 Core Concept
무한의 계단(Infinite Stairs) 모바일 게임을 PC 환경에 맞게 재해석한 아케이드 게임입니다.
플레이어는 키보드의 두 키만을 사용하여 끝없이 생성되는 계단을 올라가며,
최대한 오래 생존하고 높은 점수를 획득하는 것이 목표입니다.

### 1.2 Core Gameplay Loop
1. 게임 시작 시 난이도 선택 (Easy / Normal / Hard)
2. 플레이어 캐릭터가 계단 위에 등장
3. 좌우 키를 번갈아 눌러 계단을 한 칸씩 상승
4. 제한 시간 내에 입력하지 않으면 게임 오버
5. 장애물을 피하며 계속 상승
6. 게임 오버 시 최종 점수 표시 및 재시작 옵션

## 2. Game Mechanics

### 2.1 Player Control
- **Left Key** (A 또는 ←): 왼쪽 계단으로 이동
- **Right Key** (D 또는 →): 오른쪽 계단으로 이동
- 계단은 좌우로 번갈아 생성되며, 올바른 방향 키를 눌러야 상승
- 잘못된 키를 누르면 게임 오버

### 2.2 Stair Generation
- 계단은 무한히 생성되며 화면 아래로 스크롤
- 각 계단은 좌측 또는 우측 방향을 가짐
- 플레이어는 계단의 방향에 맞는 키를 눌러야 함
- 계단 생성 패턴은 랜덤하되, 최소 연속성 보장 (3~5칸 연속 같은 방향 제한)

### 2.3 Difficulty System

#### Easy Mode
- 입력 제한 시간: 2.5초
- 계단 스크롤 속도: 느림 (1.0x)
- 장애물 출현률: 5%
- 점수 배율: 1.0x

#### Normal Mode
- 입력 제한 시간: 1.8초
- 계단 스크롤 속도: 보통 (1.5x)
- 장애물 출현률: 15%
- 점수 배율: 1.5x

#### Hard Mode
- 입력 제한 시간: 1.2초
- 계단 스크롤 속도: 빠름 (2.0x)
- 장애물 출현률: 25%
- 점수 배율: 2.0x

### 2.4 Obstacles
- **Type 1: 균열 계단** - 밟으면 즉시 게임 오버
- **Type 2: 얼음 계단** - 입력 시간이 절반으로 감소
- **Type 3: 가시 계단** - 점수 10% 차감 (게임 오버는 아님)

장애물은 시각적으로 명확히 구분되어야 하며, 플레이어가 미리 판단할 수 있어야 함.

### 2.5 Scoring System
- 기본 점수: 계단 1칸 상승 = 10점
- 연속 성공 보너스: 10칸 연속 성공 시 +50점
- 완벽한 타이밍 보너스: 제한 시간의 80% 이내 입력 시 +5점
- 난이도 배율 적용
- 최종 점수 = (기본 점수 + 보너스) × 난이도 배율

## 3. Visual & Audio Design

### 3.1 Art Style
- 미니멀한 2D 그래픽
- 명확한 색상 구분 (계단, 장애물, 플레이어)
- 간결하고 읽기 쉬운 UI

### 3.2 Camera
- 고정 카메라 시점 (Side View)
- 플레이어는 화면 중앙~하단에 고정
- 계단이 아래로 스크롤되는 방식

### 3.3 Sound Effects
- 계단 밟기 소리
- 장애물 충돌 음
- 게임 오버 사운드
- 보너스 획득 효과음

### 3.4 Music
- 난이도별로 다른 배경음악 템포
- 루프 가능한 간단한 BGM

## 4. Game Flow

### 4.1 Main Menu
- Start Game
- Difficulty Selection
- High Scores
- Settings
- Quit

### 4.2 Game Screen
- 플레이어 캐릭터 (중앙 하단)
- 계단 (스크롤)
- 현재 점수 (우측 상단)
- 남은 시간 바 (상단 중앙)
- 일시정지 버튼

### 4.3 Game Over Screen
- 최종 점수 표시
- 최고 점수 갱신 여부
- Retry 버튼
- Main Menu 버튼

## 5. Technical Requirements

### 5.1 Performance
- 60 FPS 이상 유지
- 로딩 시간 최소화
- 입력 딜레이 < 50ms

### 5.2 Platform Support
- Windows 10/11
- macOS 12+
- Linux (Ubuntu 20.04+)

### 5.3 Save Data
- 난이도별 최고 점수
- 총 플레이 시간
- 설정 (음량, 키 바인딩)

## 6. Development Phases

### Phase 1: Core Mechanics (Week 1-2)
- 계단 생성 시스템
- 플레이어 입력 처리
- 난이도 설정 로직
- 점수 계산 시스템

### Phase 2: Visual & Polish (Week 3)
- UI 구현
- 그래픽 에셋 적용
- 애니메이션 추가

### Phase 3: Audio & Testing (Week 4)
- 사운드 이펙트 및 BGM
- 버그 수정 및 밸런싱
- 플레이테스트

## 7. Success Metrics
- 플레이어가 3회 이상 재도전할 정도의 중독성
- 난이도별로 명확한 학습 곡선
- 입력 반응성 100% (버그 없음)

---

**Version**: 1.0
**Last Updated**: 2025-11-18
**Author**: Game Design Team
