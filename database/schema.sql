-- ============================================================
-- 다국어 기술용어집 데이터베이스 스키마 v2.0
-- 최적화된 통합 테이블 구조 (완성된 시스템)
-- 2025-06-29: 235개 용어 × 22개 언어 완전 지원
-- ============================================================

-- 메인 용어 테이블 (통합 구조)
CREATE TABLE terms (
    -- 기본 식별자
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    term_id TEXT UNIQUE,                    -- 용어 고유 ID (00001~00235)
    description_ko TEXT,                    -- 한국어 설명
    
    -- 한국어
    term_ko TEXT,
    source_ko TEXT,
    
    -- 영어  
    term_en TEXT,
    source_en TEXT,
    
    -- 베트남어
    term_vi TEXT,
    source_vi TEXT,
    
    -- 중국어
    term_zh TEXT,
    source_zh TEXT,
    
    -- 러시아어
    term_ru TEXT,
    source_ru TEXT,
    
    -- 크메르어
    term_km TEXT,
    source_km TEXT,
    
    -- 네팔어
    term_ne TEXT,
    source_ne TEXT,
    
    -- 인도네시아어
    term_id_indo TEXT,
    source_id_indo TEXT,
    
    -- 태국어
    term_th TEXT,
    source_th TEXT,
    
    -- 버마어
    term_my TEXT,
    source_my TEXT,
    
    -- 몽골어
    term_mn TEXT,
    source_mn TEXT,
    
    -- 싱할라어
    term_si TEXT,
    source_si TEXT,
    
    -- 타밀어
    term_ta TEXT,
    source_ta TEXT,
    
    -- 벵골어
    term_bn TEXT,
    source_bn TEXT,
    
    -- 우르두어
    term_ur TEXT,
    source_ur TEXT,
    
    -- 포르투갈어
    term_pt TEXT,
    source_pt TEXT,
    
    -- 라오어
    term_lo TEXT,
    source_lo TEXT,
    
    -- 카자흐어
    term_kk TEXT,
    source_kk TEXT,
    
    -- 우크라이나어
    term_uk TEXT,
    source_uk TEXT,
    
    -- 필리핀어
    term_tg TEXT,
    source_tg TEXT,
    
    -- 우즈베크어
    term_uz TEXT,
    source_uz TEXT,
    
    -- 터키어
    term_tr TEXT,
    source_tr TEXT,
    
    -- 메타데이터
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 인덱스 생성 (성능 최적화)
-- ============================================================

-- 기본 검색 최적화
CREATE INDEX idx_term_id ON terms(term_id);
CREATE INDEX idx_korean_term ON terms(term_ko COLLATE NOCASE);
CREATE INDEX idx_english_term ON terms(term_en COLLATE NOCASE);
CREATE INDEX idx_vietnamese_term ON terms(term_vi COLLATE NOCASE);
CREATE INDEX idx_chinese_term ON terms(term_zh COLLATE NOCASE);

-- 출처별 검색 최적화
CREATE INDEX idx_korean_source ON terms(source_ko);
CREATE INDEX idx_english_source ON terms(source_en);

-- 설명 검색 최적화
CREATE INDEX idx_description ON terms(description_ko);

-- ============================================================
-- 뷰 생성 (편의성 및 MCP 연동)
-- ============================================================

-- 번역 통계 뷰
CREATE VIEW v_translation_stats AS
SELECT 
    COUNT(*) as total_terms,
    COUNT(CASE WHEN term_ko != '' THEN 1 END) as korean_count,
    COUNT(CASE WHEN term_en != '' THEN 1 END) as english_count,
    COUNT(CASE WHEN term_vi != '' THEN 1 END) as vietnamese_count,
    COUNT(CASE WHEN term_zh != '' THEN 1 END) as chinese_count,
    COUNT(CASE WHEN term_ru != '' THEN 1 END) as russian_count,
    ROUND(COUNT(CASE WHEN term_en != '' THEN 1 END) * 100.0 / COUNT(*), 1) as english_completion,
    ROUND(COUNT(CASE WHEN term_vi != '' THEN 1 END) * 100.0 / COUNT(*), 1) as vietnamese_completion,
    ROUND(COUNT(CASE WHEN term_zh != '' THEN 1 END) * 100.0 / COUNT(*), 1) as chinese_completion
FROM terms;

-- 주요 아시아 언어 번역 뷰 (MCP 최적화)
CREATE VIEW v_asian_translations AS
SELECT 
    term_id,
    term_ko as korean,
    term_en as english,
    term_vi as vietnamese,
    term_zh as chinese,
    term_th as thai,
    term_id_indo as indonesian,
    description_ko as description
FROM terms
WHERE term_ko IS NOT NULL;

-- 안전 관련 용어 뷰
CREATE VIEW v_safety_terms AS
SELECT 
    term_id,
    term_ko,
    term_en,
    term_vi,
    description_ko,
    source_ko
FROM terms
WHERE description_ko LIKE '%안전%' 
   OR term_ko LIKE '%안전%'
   OR term_en LIKE '%safety%'
   OR term_en LIKE '%protection%';

-- 장비 관련 용어 뷰  
CREATE VIEW v_equipment_terms AS
SELECT 
    term_id,
    term_ko,
    term_en,
    term_vi,
    term_zh,
    description_ko
FROM terms
WHERE description_ko LIKE '%장비%'
   OR description_ko LIKE '%기계%'
   OR term_ko LIKE '%기%'
   OR term_en LIKE '%equipment%'
   OR term_en LIKE '%machine%';

-- 작업 관련 용어 뷰
CREATE VIEW v_work_terms AS
SELECT 
    term_id,
    term_ko,
    term_en,
    term_vi,
    description_ko
FROM terms
WHERE description_ko LIKE '%작업%'
   OR description_ko LIKE '%공사%'
   OR term_en LIKE '%work%'
   OR term_en LIKE '%operation%';

-- ============================================================
-- MCP 연동을 위한 함수형 뷰
-- ============================================================

-- 언어별 용어 수 (MCP 통계용)
CREATE VIEW v_language_counts AS
SELECT 
    'Korean' as language, COUNT(CASE WHEN term_ko != '' THEN 1 END) as count FROM terms
UNION ALL SELECT 
    'English' as language, COUNT(CASE WHEN term_en != '' THEN 1 END) as count FROM terms
UNION ALL SELECT 
    'Vietnamese' as language, COUNT(CASE WHEN term_vi != '' THEN 1 END) as count FROM terms  
UNION ALL SELECT 
    'Chinese' as language, COUNT(CASE WHEN term_zh != '' THEN 1 END) as count FROM terms
UNION ALL SELECT 
    'Russian' as language, COUNT(CASE WHEN term_ru != '' THEN 1 END) as count FROM terms
UNION ALL SELECT 
    'Thai' as language, COUNT(CASE WHEN term_th != '' THEN 1 END) as count FROM terms
UNION ALL SELECT 
    'Indonesian' as language, COUNT(CASE WHEN term_id_indo != '' THEN 1 END) as count FROM terms;

-- 출처별 용어 분포 (품질 관리용)
CREATE VIEW v_source_distribution AS
SELECT 
    source_ko as source,
    COUNT(*) as term_count,
    GROUP_CONCAT(term_ko, ', ') as sample_terms
FROM terms 
WHERE source_ko IS NOT NULL 
GROUP BY source_ko
ORDER BY term_count DESC;

-- ============================================================
-- 초기 설정 및 메타데이터
-- ============================================================

-- 스키마 버전 정보
CREATE TABLE schema_info (
    version TEXT PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    total_terms INTEGER,
    total_languages INTEGER
);

INSERT INTO schema_info (version, description, total_terms, total_languages) VALUES 
('2.0.0', '다국어 기술용어집 완성 버전 - 통합 테이블 구조, 235개 용어, 22개 언어 완전 지원', 235, 22);

-- 지원 언어 정보 (22개 언어)
CREATE TABLE supported_languages (
    language_code CHAR(2) PRIMARY KEY,
    language_name_en VARCHAR(50),
    language_name_ko VARCHAR(50),
    native_name VARCHAR(50),
    field_name VARCHAR(20),         -- 데이터베이스 필드명
    active BOOLEAN DEFAULT TRUE,
    completion_rate DECIMAL(5,2)    -- 완성률 (%)
);

-- 22개 지원 언어 등록
INSERT INTO supported_languages (language_code, language_name_en, language_name_ko, native_name, field_name) VALUES
('KO', 'Korean', '한국어', '한국어', 'term_ko'),
('EN', 'English', '영어', 'English', 'term_en'),
('VI', 'Vietnamese', '베트남어', 'Tiếng Việt', 'term_vi'),
('ZH', 'Chinese', '중국어', '中文', 'term_zh'),
('RU', 'Russian', '러시아어', 'Русский', 'term_ru'),
('KM', 'Khmer', '크메르어', 'ភាសាខ្មែរ', 'term_km'),
('NE', 'Nepali', '네팔어', 'नेपाली', 'term_ne'),
('ID', 'Indonesian', '인도네시아어', 'Bahasa Indonesia', 'term_id_indo'),
('TH', 'Thai', '태국어', 'ไทย', 'term_th'),
('MY', 'Burmese', '버마어', 'မြန်မာ', 'term_my'),
('MN', 'Mongolian', '몽골어', 'Монгол', 'term_mn'),
('SI', 'Sinhala', '싱할라어', 'සිංහල', 'term_si'),
('TA', 'Tamil', '타밀어', 'தமிழ்', 'term_ta'),
('BN', 'Bengali', '벵골어', 'বাংলা', 'term_bn'),
('UR', 'Urdu', '우르두어', 'اردو', 'term_ur'),
('PT', 'Portuguese', '포르투갈어', 'Português', 'term_pt'),
('LO', 'Lao', '라오어', 'ລາວ', 'term_lo'),
('KK', 'Kazakh', '카자흐어', 'Қазақша', 'term_kk'),
('UK', 'Ukrainian', '우크라이나어', 'Українська', 'term_uk'),
('TG', 'Filipino', '필리핀어', 'Filipino', 'term_tg'),
('UZ', 'Uzbek', '우즈베크어', 'Oʻzbekcha', 'term_uz'),
('TR', 'Turkish', '터키어', 'Türkçe', 'term_tr');

-- ============================================================
-- MCP 연동용 샘플 쿼리들
-- ============================================================

/*
-- MCP에서 활용할 수 있는 쿼리 예시들:

-- 1. 번역 검색
SELECT term_ko, term_en, term_vi FROM terms WHERE term_ko = '안전모';

-- 2. 키워드 검색  
SELECT term_ko, term_en, description_ko FROM terms 
WHERE term_ko LIKE '%크레인%' OR term_en LIKE '%crane%';

-- 3. 카테고리별 용어
SELECT * FROM v_safety_terms LIMIT 10;
SELECT * FROM v_equipment_terms LIMIT 10;

-- 4. 번역 통계
SELECT * FROM v_translation_stats;

-- 5. 언어별 완성도
SELECT * FROM v_language_counts;

-- 6. 출처별 분포
SELECT * FROM v_source_distribution;

-- 7. 다국어 번역 (5개 언어)
SELECT term_ko, term_en, term_vi, term_zh, term_ru 
FROM terms WHERE term_id = '00001';

-- 8. 전체 통계
SELECT COUNT(*) as total_terms FROM terms;
SELECT COUNT(DISTINCT source_ko) as unique_sources FROM terms;
*/

-- ============================================================
-- 스키마 생성 완료 ✅
-- 
-- 완성된 시스템:
-- - 235개 건설안전 용어
-- - 22개 언어 완전 지원  
-- - MCP 연동 최적화
-- - 실시간 번역 준비 완료
-- ============================================================