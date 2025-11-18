# Infinite Stairs PC - Test Strategy Document

## 1. Overview

본 문서는 Infinite Stairs PC 프로젝트의 테스트 전략을 정의합니다.
TDD(Test-Driven Development)와 BDD(Behavior-Driven Development) 방법론을 기반으로,
높은 코드 품질과 안정성을 확보하는 것을 목표로 합니다.

## 2. Testing Philosophy

### 2.1 Core Principles

- **TDD First**: Core Layer는 반드시 테스트 코드를 먼저 작성
- **Red-Green-Refactor**: 실패 → 성공 → 리팩토링 사이클 준수
- **Fail Fast**: 버그는 가능한 한 빨리 발견
- **Test as Documentation**: 테스트는 코드의 사용 방법을 문서화
- **High Coverage**: Core Layer는 90% 이상 커버리지 목표

### 2.2 Testing Pyramid

```
        ┌─────────────┐
        │   Manual    │  (5% - Critical User Flows)
        │   Testing   │
        ├─────────────┤
        │     E2E     │  (10% - Key Scenarios)
        │   Testing   │
        ├─────────────┤
        │ Integration │  (25% - Layer Connections)
        │   Testing   │
        ├─────────────┤
        │    Unit     │  (60% - Core Business Logic)
        │   Testing   │
        └─────────────┘
```

## 3. Testing Framework

### 3.1 Tool Selection

**GUT (Godot Unit Test)**
- Godot 공식 지원 테스트 프레임워크
- BDD 스타일 테스트 작성 가능
- GDScript 네이티브 지원

**Installation**:
```bash
# GUT addon 설치 (AssetLib 또는 GitHub)
# addons/gut/ 에 설치
```

### 3.2 Test File Naming

```
src/core/difficulty/difficulty_config.gd
→ tests/unit/core/difficulty/test_difficulty_config.gd

src/application/controllers/game_controller.gd
→ tests/integration/application/test_game_controller.gd
```

**규칙**:
- 테스트 파일명은 `test_` 접두사 사용
- 원본 파일 경로 구조를 tests/ 아래에 동일하게 유지

## 4. Test Levels

### 4.1 Unit Tests (`tests/unit/`)

**목적**: 개별 클래스/함수의 정확성 검증
**범위**: Core Layer 전체
**특징**:
- 외부 의존성 없음 (Pure GDScript)
- 빠른 실행 속도 (< 1ms per test)
- Mock/Stub 사용 최소화

**Example**:
```gdscript
# tests/unit/core/score/test_score_calculator.gd
extends GutTest

var calculator: ScoreCalculator

func before_each():
    calculator = ScoreCalculator.new()

func test_calculate_basic_score():
    # Given
    var stairs_climbed = 10
    var difficulty_multiplier = 1.0

    # When
    var score = calculator.calculate_basic_score(stairs_climbed, difficulty_multiplier)

    # Then
    assert_eq(score, 100, "10 stairs * 10 points * 1.0x = 100")

func test_calculate_combo_bonus():
    # Given
    var consecutive_success = 10

    # When
    var bonus = calculator.calculate_combo_bonus(consecutive_success)

    # Then
    assert_eq(bonus, 50, "10 consecutive = 50 bonus points")

func test_calculate_combo_bonus_returns_zero_when_below_threshold():
    # Given
    var consecutive_success = 5

    # When
    var bonus = calculator.calculate_combo_bonus(consecutive_success)

    # Then
    assert_eq(bonus, 0, "Below 10 consecutive should give no bonus")
```

**Coverage Target**: 90% 이상

### 4.2 Integration Tests (`tests/integration/`)

**목적**: 레이어 간 상호작용 검증
**범위**: Application Layer ↔ Core Layer
**특징**:
- 여러 컴포넌트의 협력 테스트
- Mock/Stub을 사용한 외부 의존성 격리

**Example**:
```gdscript
# tests/integration/application/test_game_controller.gd
extends GutTest

var game_controller: GameController
var mock_difficulty_manager: MockDifficultyManager
var mock_score_tracker: MockScoreTracker

func before_each():
    mock_difficulty_manager = MockDifficultyManager.new()
    mock_score_tracker = MockScoreTracker.new()
    game_controller = GameController.new(mock_difficulty_manager, mock_score_tracker)

func test_process_correct_input_increases_score():
    # Given
    game_controller.start_game(Difficulty.NORMAL)
    var initial_score = game_controller.get_score()

    # When
    game_controller.process_input(Input.LEFT)

    # Then
    assert_gt(game_controller.get_score(), initial_score, "Score should increase")

func test_process_wrong_input_triggers_game_over():
    # Given
    game_controller.start_game(Difficulty.NORMAL)
    stub_next_stair_direction(Direction.LEFT)

    # When
    game_controller.process_input(Input.RIGHT)  # Wrong input

    # Then
    assert_true(game_controller.is_game_over(), "Game should be over on wrong input")
```

**Coverage Target**: 70% 이상

### 4.3 End-to-End Tests (`tests/e2e/`)

**목적**: 실제 사용자 시나리오 검증
**범위**: 전체 게임 플로우
**특징**:
- Godot Scene 기반 테스트
- 주요 사용자 시나리오만 선택적으로 자동화

**Example Scenarios**:
1. 메인 메뉴 → 난이도 선택 → 게임 시작 → 게임 오버 → 재시작
2. 10칸 연속 성공 → 콤보 보너스 획득
3. 장애물 충돌 → 게임 오버

**Coverage Target**: 주요 시나리오 3~5개

### 4.4 Manual Tests

**목적**: 시각적/사운드/UX 품질 검증
**범위**: UI/UX, 그래픽, 사운드
**체크리스트**:
- [ ] 모든 버튼이 정상 작동하는가?
- [ ] 그래픽이 올바르게 표시되는가?
- [ ] 사운드가 적절한 타이밍에 재생되는가?
- [ ] 게임 속도가 난이도에 맞게 조정되는가?
- [ ] 입력 반응이 즉각적인가?

## 5. TDD Workflow

### 5.1 Red-Green-Refactor Cycle

```
1. RED: Write a failing test
   └─> 구현하고자 하는 기능의 테스트 작성

2. GREEN: Make the test pass
   └─> 테스트를 통과시키는 최소한의 코드 작성

3. REFACTOR: Improve the code
   └─> 중복 제거, 가독성 향상, 성능 최적화

4. REPEAT
```

### 5.2 TDD Example: DifficultyConfig

**Step 1: Write Test (RED)**
```gdscript
# tests/unit/core/difficulty/test_difficulty_config.gd
extends GutTest

func test_easy_difficulty_has_correct_input_timeout():
    # Given
    var config = DifficultyConfig.new()

    # When
    var timeout = config.get_input_timeout(Difficulty.EASY)

    # Then
    assert_eq(timeout, 2.5, "Easy mode should have 2.5s timeout")
```

**Run Test** → FAIL (DifficultyConfig doesn't exist yet)

**Step 2: Implement (GREEN)**
```gdscript
# src/core/difficulty/difficulty_config.gd
class_name DifficultyConfig

const EASY_INPUT_TIMEOUT = 2.5

func get_input_timeout(difficulty: int) -> float:
    if difficulty == Difficulty.EASY:
        return EASY_INPUT_TIMEOUT
    return 0.0
```

**Run Test** → PASS

**Step 3: Refactor**
```gdscript
# src/core/difficulty/difficulty_config.gd
class_name DifficultyConfig

const INPUT_TIMEOUTS = {
    Difficulty.EASY: 2.5,
    Difficulty.NORMAL: 1.8,
    Difficulty.HARD: 1.2
}

func get_input_timeout(difficulty: int) -> float:
    return INPUT_TIMEOUTS.get(difficulty, 0.0)
```

**Run Test** → PASS (still passes after refactoring)

## 6. Test Organization

### 6.1 Directory Structure

```
tests/
├── unit/
│   ├── core/
│   │   ├── difficulty/
│   │   │   ├── test_difficulty_config.gd
│   │   │   └── test_difficulty_manager.gd
│   │   ├── score/
│   │   │   ├── test_score_calculator.gd
│   │   │   └── test_score_tracker.gd
│   │   ├── stair/
│   │   │   ├── test_stair_generator.gd
│   │   │   └── test_stair_validator.gd
│   │   └── obstacle/
│   │       └── test_obstacle_factory.gd
│   └── test_suite_unit.gd
├── integration/
│   ├── application/
│   │   ├── test_game_controller.gd
│   │   └── test_menu_controller.gd
│   └── test_suite_integration.gd
├── e2e/
│   ├── test_main_game_flow.gd
│   └── test_suite_e2e.gd
├── mocks/
│   ├── mock_difficulty_manager.gd
│   ├── mock_score_tracker.gd
│   └── mock_stair_generator.gd
└── gut_config.gd
```

### 6.2 Test Suite Configuration

```gdscript
# tests/gut_config.gd
extends GutTest

func _ready():
    # Unit tests run first (fastest)
    add_directory("res://tests/unit/")

    # Integration tests
    add_directory("res://tests/integration/")

    # E2E tests (slowest, run last)
    add_directory("res://tests/e2e/")
```

## 7. Test Coverage

### 7.1 Priority Test Targets

**High Priority (Must Test)**:
- [ ] DifficultyConfig - 난이도 설정값
- [ ] ScoreCalculator - 점수 계산 로직
- [ ] StairGenerator - 계단 생성 로직
- [ ] StairValidator - 입력 검증
- [ ] InputTimer - 입력 시간 제한
- [ ] ObstacleFactory - 장애물 생성
- [ ] GameStateManager - 게임 상태 전환

**Medium Priority (Should Test)**:
- [ ] ScoreTracker - 점수 추적
- [ ] GameController - 게임 플로우
- [ ] SaveService - 저장/불러오기

**Low Priority (Optional Test)**:
- UI Components (수동 테스트로 대체 가능)
- Audio Service (수동 테스트로 대체 가능)

### 7.2 Coverage Measurement

```bash
# GUT에서 커버리지 리포트 생성
# (GUT는 내장 커버리지 도구가 없으므로, 테스트 실행 여부로 간접 측정)
```

**목표**:
- Core Layer: 90% 이상
- Application Layer: 70% 이상
- UI Layer: 수동 테스트로 커버

## 8. BDD Style Testing

### 8.1 Given-When-Then Pattern

모든 테스트는 BDD 스타일로 작성하여 가독성을 높입니다.

```gdscript
func test_player_loses_when_time_runs_out():
    # Given (초기 상태 설정)
    var timer = InputTimer.new(1.0)  # 1 second timeout
    timer.start()

    # When (행동 실행)
    await get_tree().create_timer(1.1).timeout  # Wait longer than timeout

    # Then (결과 검증)
    assert_true(timer.is_expired(), "Timer should be expired after 1.1 seconds")
```

### 8.2 Descriptive Test Names

테스트 이름은 "무엇을_언제_어떻게" 형식으로 작성합니다.

```gdscript
# GOOD
func test_score_calculator_returns_zero_when_no_stairs_climbed()
func test_stair_generator_creates_left_stair_when_previous_was_right()
func test_game_over_triggers_when_wrong_input_provided()

# BAD
func test_score()
func test_stair()
func test_input()
```

## 9. Mock & Stub Strategy

### 9.1 When to Mock

**Mock을 사용하는 경우**:
- 외부 시스템 의존성 (파일 I/O, 네트워크)
- Godot 노드/씬 (Unit Test에서)
- 느린 작업 (대량 데이터 생성 등)

**Mock을 사용하지 않는 경우**:
- Pure function 테스트
- 단순 데이터 객체

### 9.2 Mock Example

```gdscript
# tests/mocks/mock_stair_generator.gd
class_name MockStairGenerator
extends StairGenerator

var next_stair_direction: int = Direction.LEFT

func generate_next_stair() -> Stair:
    var stair = Stair.new()
    stair.direction = next_stair_direction
    return stair

func set_next_direction(direction: int) -> void:
    next_stair_direction = direction
```

## 10. Continuous Integration

### 10.1 CI Pipeline (Future)

```yaml
# .github/workflows/test.yml
name: Run Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Godot
        uses: abarichello/godot-ci@v3
      - name: Run Unit Tests
        run: godot --headless --path . res://tests/test_suite_unit.gd
      - name: Run Integration Tests
        run: godot --headless --path . res://tests/test_suite_integration.gd
```

### 10.2 Pre-commit Hook

```bash
#!/bin/bash
# .git/hooks/pre-commit
echo "Running tests before commit..."
godot --headless --path . res://tests/test_suite_unit.gd
if [ $? -ne 0 ]; then
    echo "Tests failed! Commit aborted."
    exit 1
fi
```

## 11. Testing Checklist

개발 시 아래 체크리스트를 따릅니다:

- [ ] Core Layer 신규 기능 작성 전 테스트 코드 먼저 작성
- [ ] 모든 테스트는 Given-When-Then 구조로 작성
- [ ] 테스트 이름은 명확하고 설명적으로 작성
- [ ] 각 테스트는 하나의 기능만 검증
- [ ] Red-Green-Refactor 사이클 준수
- [ ] 리팩토링 후 모든 테스트 재실행
- [ ] 커밋 전 전체 테스트 스위트 실행

## 12. Next Steps - TDD Priority

첫 번째 TDD 사이클에서 구현할 핵심 기능:

1. **DifficultyConfig** - 난이도 설정 관리
2. **StairGenerator** - 계단 생성 로직
3. **ScoreCalculator** - 점수 계산 로직

각 기능은 테스트 코드 작성 → 구현 → 리팩토링 순서로 진행합니다.

---

**Version**: 1.0
**Last Updated**: 2025-11-18
**Author**: Development Team
