-- ============================================================
-- 다국어 기술용어집 데이터베이스 스키마
-- 언어 중립적 번역 시스템을 위한 단일 테이블 구조
-- ============================================================

-- 메인 용어 테이블
CREATE TABLE terms (
    -- 기본 식별자
    term_id VARCHAR(8) PRIMARY KEY,     -- 'EN00001', 'VI00001', 'KO00001' 등
    term_text VARCHAR(500) NOT NULL,    -- 실제 용어/번역문
    
    -- 품질 관리
    source_code VARCHAR(20),            -- 'KOSHA001', 'OSHA001', 'AUTO001' 등
    confidence_score DECIMAL(3,2) DEFAULT 0.8,  -- 신뢰도 (0.0-1.0)
    auto_generated BOOLEAN DEFAULT FALSE,        -- 자동 생성 여부
    
    -- 사용 통계
    lookup_count INTEGER DEFAULT 0,     -- 조회 횟수
    
    -- 시간 정보
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_accessed TIMESTAMP,
    
    -- 제약 조건
    CHECK (confidence_score >= 0.0 AND confidence_score <= 1.0),
    CHECK (lookup_count >= 0),
    CHECK (LENGTH(term_id) = 7 OR LENGTH(term_id) = 8)  -- XX00001 또는 XXX00001
);

-- ============================================================
-- 인덱스 생성 (성능 최적화)
-- ============================================================

-- 기본 검색 최적화
CREATE INDEX idx_term_text ON terms(term_text COLLATE NOCASE);

-- 언어별 검색 최적화 (term_id 앞 2글자)
CREATE INDEX idx_language_prefix ON terms(SUBSTR(term_id, 1, 2));

-- base_id 검색 최적화 (term_id 뒤 5글자)
CREATE INDEX idx_base_id ON terms(SUBSTR(term_id, 3));

-- 인기 용어 조회 최적화
CREATE INDEX idx_lookup_count ON terms(lookup_count DESC);

-- 품질 관리용 인덱스
CREATE INDEX idx_confidence_lookup ON terms(confidence_score, lookup_count DESC);
CREATE INDEX idx_auto_generated ON terms(auto_generated, created_at DESC);

-- 언어별 + 인기도 복합 인덱스
CREATE INDEX idx_language_popularity ON terms(SUBSTR(term_id, 1, 2), lookup_count DESC);

-- ============================================================
-- 뷰 생성 (편의성)
-- ============================================================

-- 언어별 용어 현황
CREATE VIEW v_language_stats AS
SELECT 
    SUBSTR(term_id, 1, 2) as language_code,
    COUNT(*) as term_count,
    AVG(confidence_score) as avg_confidence,
    SUM(lookup_count) as total_lookups,
    MAX(lookup_count) as max_lookups
FROM terms 
GROUP BY SUBSTR(term_id, 1, 2)
ORDER BY term_count DESC;

-- 품질이 낮은 용어 (검증 필요)
CREATE VIEW v_low_quality_terms AS
SELECT 
    term_id,
    term_text,
    SUBSTR(term_id, 1, 2) as language_code,
    confidence_score,
    lookup_count,
    source_code,
    auto_generated
FROM terms
WHERE confidence_score < 0.8 
   OR (auto_generated = TRUE AND lookup_count > 5)
ORDER BY lookup_count DESC, confidence_score ASC;

-- 인기 용어 TOP 100
CREATE VIEW v_popular_terms AS
SELECT 
    term_id,
    term_text,
    SUBSTR(term_id, 1, 2) as language_code,
    SUBSTR(term_id, 3) as base_id,
    lookup_count,
    confidence_score,
    source_code
FROM terms
ORDER BY lookup_count DESC
LIMIT 100;

-- ============================================================
-- 함수/트리거 (SQLite 지원 범위 내)
-- ============================================================

-- 조회수 자동 업데이트용 트리거
CREATE TRIGGER update_last_accessed
AFTER UPDATE OF lookup_count ON terms
BEGIN
    UPDATE terms 
    SET last_accessed = CURRENT_TIMESTAMP 
    WHERE term_id = NEW.term_id;
END;

-- 신규 용어 생성시 기본값 설정
CREATE TRIGGER set_new_term_defaults
AFTER INSERT ON terms
BEGIN
    UPDATE terms 
    SET last_accessed = CURRENT_TIMESTAMP 
    WHERE term_id = NEW.term_id AND NEW.last_accessed IS NULL;
END;

-- ============================================================
-- 초기 설정 완료
-- ============================================================

-- 스키마 버전 정보 (메타데이터)
CREATE TABLE schema_info (
    version TEXT PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT
);

INSERT INTO schema_info (version, description) VALUES 
('1.0.0', '다국어 기술용어집 초기 스키마 - 언어 중립적 번역 시스템');

-- 지원 언어 정보
CREATE TABLE supported_languages (
    language_code CHAR(2) PRIMARY KEY,
    language_name_en VARCHAR(50),
    language_name_ko VARCHAR(50),
    native_name VARCHAR(50),
    active BOOLEAN DEFAULT TRUE
);

-- 22개 지원 언어 등록
INSERT INTO supported_languages (language_code, language_name_en, language_name_ko, native_name) VALUES
('KO', 'Korean', '한국어', '한국어'),
('EN', 'English', '영어', 'English'),
('VI', 'Vietnamese', '베트남어', 'Tiếng Việt'),
('ZH', 'Chinese', '중국어', '中文'),
('RU', 'Russian', '러시아어', 'Русский'),
('KM', 'Khmer', '크메르어', 'ភាសាខ្មែរ'),
('NE', 'Nepali', '네팔어', 'नेपाली'),
('ID', 'Indonesian', '인도네시아어', 'Bahasa Indonesia'),
('TH', 'Thai', '태국어', 'ไทย'),
('MY', 'Burmese', '버마어', 'မြန်မာ'),
('MN', 'Mongolian', '몽골어', 'Монгол'),
('SI', 'Sinhala', '싱할라어', 'සිංහල'),
('TA', 'Tamil', '타밀어', 'தமிழ்'),
('BN', 'Bengali', '벵골어', 'বাংলা'),
('UR', 'Urdu', '우르두어', 'اردو'),
('PT', 'Portuguese', '포르투갈어', 'Português'),
('LO', 'Lao', '라오어', 'ລາວ'),
('KK', 'Kazakh', '카자흐어', 'Қазақша'),
('UK', 'Ukrainian', '우크라이나어', 'Українська'),
('TGL', 'Filipino', '필리핀어', 'Filipino'),
('UZ', 'Uzbek', '우즈베크어', 'Oʻzbekcha'),
('TR', 'Turkish', '튀르크어', 'Türkçe');

-- ============================================================
-- 스키마 생성 완료
-- 이제 sample-data.sql로 테스트 데이터를 추가하세요
-- ============================================================