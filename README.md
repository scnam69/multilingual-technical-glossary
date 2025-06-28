# 🌍 다국어 기술용어집 개발 프로젝트

> 건설안전 번역 시스템을 위한 언어 중립적 용어 데이터베이스

## 🎯 프로젝트 목표

이 프로젝트는 **"생명을 구하는 번역"** 철학을 바탕으로, 한국 건설현장에서 일하는 외국인 근로자들을 위한 다국어 기술용어집 시스템을 개발합니다.

### 핵심 특징
- 🌍 **언어 중립적 구조**: 어떤 언어에서든 어떤 언어로든 번역 가능
- ⚡ **고속 검색**: 용어 ID 기반 즉시 번역
- 🔄 **자동 확장**: 신규 용어 자동 등록 및 관리
- 📊 **품질 관리**: 출처 추적 및 신뢰도 관리

## 🏗️ 시스템 구조

### ID 체계
```
[언어코드][고유번호] → 번역문
EN00001 → Heavy equipment
VI00001 → Thiết bị hạng nặng
ZH00001 → 重型设备
KO00001 → 중장비
```

### 지원 언어 (22개국)
한국어(KO), 영어(EN), 베트남어(VI), 중국어(ZH), 러시아어(RU), 크메르어(KM), 네팔어(NE), 인도네시아어(ID), 태국어(TH), 버마어(MY), 몽고어(MN), 싱할라어(SI), 타밀어(TA), 벵골어(BN), 우르드어(UR), 포르투갈어(PT), 라오어(LO), 카자흐어(KK), 우크라이나어(UK), 필리핀어(TGL), 우즈베크어(UZ), 튀르크어(TR)

## 📁 프로젝트 구조

```
multilingual-technical-glossary/
├── docs/                     # 문서
│   ├── database-design.md    # DB 설계 문서
│   ├── system-architecture.md # 시스템 구조
│   └── api-specification.md  # API 명세
├── database/                 # 데이터베이스
│   ├── schema.sql           # DB 스키마
│   ├── sample-data.sql      # 샘플 데이터
│   └── migration/           # 마이그레이션 스크립트
├── tools/                   # 개발 도구
│   ├── import-tools/        # 데이터 가져오기 도구
│   └── mcp-connector/       # MCP 연동 도구
└── data/                    # 원본 데이터
    ├── existing-glossary/   # 기존 용어집
    └── import-templates/    # Import 템플릿
```

## 🚀 시작하기

### 1. SQLite 설치 (macOS)
```bash
# Homebrew로 SQLite 설치
brew install sqlite

# DB Browser for SQLite 설치 (GUI 도구)
brew install --cask db-browser-for-sqlite

# 설치 확인
sqlite3 --version
```

### 2. 데이터베이스 생성
```bash
# 프로젝트 폴더로 이동
cd multilingual-technical-glossary

# 데이터베이스 생성
sqlite3 database/glossary.db < database/schema.sql
sqlite3 database/glossary.db < database/sample-data.sql
```

### 3. 샘플 번역 테스트
```sql
-- 영어 "Crane"을 베트남어로 번역
SELECT 
    source.term_text as 원문,
    target.term_text as 번역문,
    target.source_code as 출처
FROM terms source, terms target
WHERE source.term_text = 'Crane'
  AND source.term_id LIKE 'EN%'
  AND target.term_id = 'VI' || SUBSTR(source.term_id, 3);
```

## 📋 진행 상황

- [x] 프로젝트 설계 및 구조 정의
- [x] SQLite 스키마 설계
- [ ] 기존 엑셀 데이터 변환 및 Import
- [ ] MCP 연동 도구 개발
- [ ] 번역 프롬프트 시스템 연동
- [ ] 웹 검색 기반 신규 용어 자동 등록
- [ ] 품질 관리 및 검증 시스템

## 🤝 기여하기

이 프로젝트는 건설현장 안전을 위한 오픈소스 프로젝트입니다. 기여를 환영합니다!

## 📄 라이선스

MIT License - 자유롭게 사용, 수정, 배포하실 수 있습니다.

---

**"생명을 구하는 번역"** - 언어 장벽으로 인한 건설현장 사고를 예방하는 것이 우리의 최우선 목표입니다.