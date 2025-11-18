# Infinite Stairs PC

PC용 2D 아케이드 게임 - 무한의 계단 (Infinite Stairs)

## 개요

모바일 게임 "무한의 계단"을 PC 환경에 맞게 재해석한 아케이드 게임입니다.
키보드의 두 키만을 사용하여 끝없이 생성되는 계단을 올라가며,
최대한 오래 생존하고 높은 점수를 획득하는 것이 목표입니다.

## 기술 스택

- **Engine**: Godot 4.x
- **Language**: GDScript
- **Platform**: PC (Windows, Linux, macOS)
- **Testing**: GUT (Godot Unit Test)

## 개발 원칙

- TDD (Test-Driven Development)
- BDD (Behavior-Driven Development)
- SOLID, DRY, KISS
- Clean Architecture
- Error-First / Fail Fast

## 프로젝트 구조

```
infinite-stairs-pc/
├── docs/                    # 설계 문서
│   ├── GAME_DESIGN.md      # 게임 기획서
│   ├── ARCHITECTURE.md     # 아키텍처 설계
│   └── TEST_STRATEGY.md    # 테스트 전략
├── src/
│   ├── core/               # Core Layer (Pure Logic)
│   ├── application/        # Application Layer (Controllers)
│   └── ui/                 # UI Layer (View Scripts)
├── scenes/                 # Godot Scenes (.tscn)
├── assets/                 # Graphics, Audio, Fonts
├── tests/
│   ├── unit/               # Unit Tests
│   ├── integration/        # Integration Tests
│   └── e2e/                # End-to-End Tests
└── project.godot           # Godot Project File
```

## 시작하기

### 요구사항

- Godot 4.3 이상

### 실행

1. Godot Engine에서 프로젝트 열기
2. F5 키로 게임 실행

### 테스트 실행

1. GUT addon 설치 필요
2. Godot Editor에서 GUT 패널 열기
3. "Run All" 버튼 클릭

## 다음 단계

TDD 방식으로 다음 기능들을 구현할 예정:

1. **DifficultyConfig** - 난이도 설정 관리
2. **StairGenerator** - 계단 생성 로직
3. **ScoreCalculator** - 점수 계산 로직

## 문서

자세한 내용은 `docs/` 폴더의 문서를 참고하세요:

- [게임 기획서](docs/GAME_DESIGN.md)
- [아키텍처 설계](docs/ARCHITECTURE.md)
- [테스트 전략](docs/TEST_STRATEGY.md)

## 라이선스

MIT License
