# Infinite Stairs PC - Architecture Document

## 1. Overview

본 문서는 Infinite Stairs PC의 소프트웨어 아키텍처를 정의합니다.
클린 아키텍처와 레이어드 아키텍처 원칙을 따르며,
테스트 가능성과 유지보수성을 최우선으로 설계되었습니다.

## 2. Architecture Principles

### 2.1 Core Principles
- **SOLID**: 단일 책임, 개방-폐쇄, 리스코프 치환, 인터페이스 분리, 의존성 역전
- **DRY**: Don't Repeat Yourself
- **KISS**: Keep It Simple, Stupid
- **Separation of Concerns**: 관심사의 분리
- **Dependency Inversion**: 고수준 모듈이 저수준 모듈에 의존하지 않음

### 2.2 Design Patterns
- **Dependency Injection**: 의존성 주입을 통한 결합도 감소
- **Strategy Pattern**: 난이도별 설정 전환
- **Observer Pattern**: 이벤트 기반 통신
- **Factory Pattern**: 계단 및 장애물 생성
- **State Pattern**: 게임 상태 관리

## 3. Layer Architecture

```
┌─────────────────────────────────────┐
│   UI Layer (Godot Scenes/Nodes)    │  ← User Interaction
├─────────────────────────────────────┤
│   Application Layer (Controllers)  │  ← Game Flow Control
├─────────────────────────────────────┤
│   Domain/Core Layer (Pure Logic)   │  ← Business Logic (Pure GDScript)
└─────────────────────────────────────┘
```

### 3.1 Domain/Core Layer (`src/core/`)

**책임**: 게임의 핵심 비즈니스 로직 구현
**특징**:
- Godot 노드에 의존하지 않음 (Pure GDScript)
- 100% 단위 테스트 가능
- 외부 의존성 없음 (순수 함수 중심)

**주요 컴포넌트**:

```
src/core/
├── difficulty/
│   ├── difficulty_config.gd         # 난이도 설정 데이터
│   └── difficulty_manager.gd        # 난이도 관리 로직
├── stair/
│   ├── stair.gd                     # 계단 데이터 모델
│   ├── stair_generator.gd           # 계단 생성 로직
│   └── stair_validator.gd           # 계단 입력 검증
├── score/
│   ├── score_calculator.gd          # 점수 계산 로직
│   └── score_tracker.gd             # 점수 추적 및 보너스
├── obstacle/
│   ├── obstacle.gd                  # 장애물 데이터 모델
│   └── obstacle_factory.gd          # 장애물 생성 로직
├── input/
│   ├── input_timer.gd               # 입력 제한 시간 관리
│   └── input_validator.gd           # 입력 검증 로직
└── game_state/
    ├── game_state.gd                # 게임 상태 데이터
    └── game_state_manager.gd       # 게임 상태 전환 로직
```

**설계 원칙**:
- 모든 클래스는 단위 테스트 가능
- 외부 상태 변경 최소화 (Pure Function 선호)
- 명확한 입출력 정의
- 의존성 주입 사용

### 3.2 Application Layer (`src/application/`)

**책임**: 게임 플로우 제어 및 Core Layer와 UI Layer 연결
**특징**:
- Core Layer의 로직을 조합하여 게임 플로우 구성
- UI 이벤트를 Core 로직으로 전달
- Godot의 시그널(Signal) 활용

**주요 컴포넌트**:

```
src/application/
├── controllers/
│   ├── game_controller.gd           # 메인 게임 플로우 제어
│   ├── menu_controller.gd           # 메뉴 플로우 제어
│   └── score_controller.gd          # 점수 표시 제어
├── services/
│   ├── save_service.gd              # 저장/불러오기 서비스
│   ├── audio_service.gd             # 오디오 재생 서비스
│   └── config_service.gd            # 설정 관리 서비스
└── events/
    └── game_events.gd                # 전역 이벤트 버스
```

**설계 원칙**:
- Controller는 얇게 유지 (Thin Controller)
- 비즈니스 로직은 Core Layer에 위임
- UI와 Core 사이의 데이터 변환 담당

### 3.3 UI Layer (`src/ui/`, `scenes/`)

**책임**: 사용자 인터페이스 및 시각적 표현
**특징**:
- Godot Scene 및 Node 활용
- 사용자 입력 수신 및 Application Layer로 전달
- 게임 상태를 시각적으로 표현

**주요 컴포넌트**:

```
scenes/
├── main.tscn                        # 메인 씬
├── menu/
│   ├── main_menu.tscn               # 메인 메뉴
│   ├── difficulty_select.tscn       # 난이도 선택
│   └── game_over.tscn               # 게임 오버 화면
├── game/
│   ├── game_scene.tscn              # 메인 게임 씬
│   ├── player.tscn                  # 플레이어 캐릭터
│   ├── stair_view.tscn              # 계단 시각 컴포넌트
│   └── obstacle_view.tscn           # 장애물 시각 컴포넌트
└── hud/
    ├── score_display.tscn           # 점수 표시 UI
    ├── timer_bar.tscn               # 시간 제한 바
    └── pause_menu.tscn              # 일시정지 메뉴

src/ui/
├── components/
│   ├── score_label.gd               # 점수 표시 컴포넌트
│   ├── timer_bar.gd                 # 타이머 바 컴포넌트
│   └── button_base.gd               # 공통 버튼 베이스
└── views/
    ├── game_view.gd                 # 게임 화면 뷰
    ├── menu_view.gd                 # 메뉴 화면 뷰
    └── hud_view.gd                  # HUD 뷰
```

**설계 원칙**:
- UI는 상태를 소유하지 않음 (Stateless)
- Application Layer의 명령만 수행
- 비즈니스 로직 포함 금지

## 4. Data Flow

### 4.1 Input Flow
```
User Input → UI Layer → Application Controller → Core Logic → State Update
```

### 4.2 Render Flow
```
Core State → Application Controller → UI Layer → Screen Rendering
```

### 4.3 Example: Player Input Processing

```
1. Player presses LEFT key
2. game_view.gd receives input event
3. game_view emits signal to game_controller
4. game_controller calls input_validator.validate(LEFT, current_stair)
5. input_validator returns validation result
6. game_controller updates game_state via game_state_manager
7. game_controller calls score_calculator.calculate()
8. game_controller emits state_changed signal
9. UI components update based on new state
```

## 5. Dependency Rules

### 5.1 Layer Dependencies
```
UI Layer ──────→ Application Layer ──────→ Core Layer
   ↓                    ↓                       ↓
 Godot            Controllers              Pure Logic
 Nodes            Services                 (No Godot)
```

**규칙**:
- Core Layer는 다른 레이어에 의존하지 않음
- Application Layer는 Core Layer에만 의존
- UI Layer는 Application Layer에만 의존

### 5.2 Dependency Injection Example

```gdscript
# BAD: Direct instantiation (hard dependency)
class_name GameController

var score_calculator = ScoreCalculator.new()

# GOOD: Dependency injection (loose coupling)
class_name GameController

var score_calculator: ScoreCalculator

func _init(calculator: ScoreCalculator):
    score_calculator = calculator
```

## 6. Testing Strategy Integration

### 6.1 Testable Architecture
```
Core Layer        → Unit Tests (100% coverage goal)
Application Layer → Integration Tests
UI Layer          → Manual/E2E Tests (minimal automation)
```

### 6.2 Test Boundaries
- **Core Layer**: 모든 public 메서드는 단위 테스트 대상
- **Application Layer**: Controller 메서드는 통합 테스트 대상
- **UI Layer**: 주로 수동 테스트, 중요 기능만 자동화

## 7. Error Handling

### 7.1 Error-First Principle
모든 함수는 에러 상황을 우선적으로 처리합니다.

```gdscript
func validate_input(input: int, stair_direction: int) -> Dictionary:
    # Error cases first
    if input not in [LEFT, RIGHT]:
        return {\"success\": false, \"error\": \"Invalid input\"}

    if stair_direction not in [LEFT, RIGHT]:
        return {\"success\": false, \"error\": \"Invalid stair direction\"}

    # Success case
    return {\"success\": input == stair_direction, \"error\": \"\"}
```

### 7.2 Fail Fast
잘못된 상태는 즉시 감지하고 처리합니다.

```gdscript
func set_difficulty(difficulty: int) -> void:
    assert(difficulty in [EASY, NORMAL, HARD], \"Invalid difficulty level\")
    _difficulty = difficulty
```

## 8. File Organization

```
infinite-stairs-pc/
├── project.godot
├── docs/
│   ├── GAME_DESIGN.md
│   ├── ARCHITECTURE.md
│   └── TEST_STRATEGY.md
├── src/
│   ├── core/              # Domain/Business Logic (Pure GDScript)
│   ├── application/       # Controllers & Services
│   └── ui/                # UI Scripts
├── scenes/                # Godot Scene files (.tscn)
├── assets/                # Graphics, Audio, Fonts
│   ├── sprites/
│   ├── sounds/
│   └── fonts/
├── tests/
│   ├── unit/              # Core Layer unit tests
│   ├── integration/       # Application Layer tests
│   └── gut_config.gd      # GUT test configuration
└── addons/
    └── gut/               # Godot Unit Test framework
```

## 9. Best Practices

### 9.1 Code Organization
- 한 파일에 하나의 클래스만 정의
- 파일명은 클래스명과 동일 (snake_case)
- 디렉토리는 기능별로 구분

### 9.2 Naming Conventions
- **Classes**: PascalCase (e.g., `ScoreCalculator`)
- **Files**: snake_case (e.g., `score_calculator.gd`)
- **Variables**: snake_case (e.g., `current_score`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `MAX_SCORE`)
- **Private**: prefix with `_` (e.g., `_internal_state`)

### 9.3 Comments
- Public API는 반드시 주석 작성
- 복잡한 로직은 설명 주석 추가
- TODO는 이슈 트래커와 연동

## 10. Future Considerations

### 10.1 Scalability
- 추가 게임 모드 지원을 위한 확장 가능한 구조
- 멀티플레이어 기능 추가 가능성 고려

### 10.2 Performance
- Object Pooling for 계단 및 장애물 생성
- Scene Caching for 빠른 화면 전환

---

**Version**: 1.0
**Last Updated**: 2025-11-18
**Author**: Development Team
