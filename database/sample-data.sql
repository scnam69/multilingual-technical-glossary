-- ============================================================
-- 다국어 기술용어집 샘플 데이터
-- 테스트 및 개발용 기본 데이터
-- ============================================================

-- ============================================================
-- 개인보호구 관련 용어 (00001-00010)
-- ============================================================

-- 안전모 / Safety Helmet (00001)
INSERT INTO terms (term_id, term_text, source_code, confidence_score, lookup_count) VALUES
('KO00001', '안전모', 'KOSHA001', 0.95, 45),
('EN00001', 'Safety Helmet', 'OSHA001', 0.95, 45),
('VI00001', 'Mũ bảo hộ', 'AUTO001', 0.90, 45),
('ZH00001', '安全帽', 'AUTO002', 0.92, 45);

-- 안전화 / Safety Boots (00002)
INSERT INTO terms (term_id, term_text, source_code, confidence_score, lookup_count) VALUES
('KO00002', '안전화', 'KOSHA002', 0.95, 38),
('EN00002', 'Safety Boots', 'OSHA002', 0.93, 38),
('VI00002', 'Giày bảo hộ', 'AUTO003', 0.88, 38),
('ZH00002', '安全靴', 'AUTO004', 0.90, 38);

-- 안전대 / Safety Harness (00003)
INSERT INTO terms (term_id, term_text, source_code, confidence_score, lookup_count) VALUES
('KO00003', '안전대', 'KOSHA003', 0.94, 25),
('EN00003', 'Safety Harness', 'OSHA003', 0.96, 25),
('VI00003', 'Dây an toàn', 'AUTO005', 0.87, 25),
('ZH00003', '安全带', 'AUTO006', 0.91, 25);

-- 장갑 / Protective Gloves (00004)
INSERT INTO terms (term_id, term_text, source_code, confidence_score, lookup_count) VALUES
('KO00004', '장갑', 'KOSHA004', 0.93, 32),
('EN00004', 'Protective Gloves', 'ANSI001', 0.94, 32),
('VI00004', 'Găng tay bảo hộ', 'AUTO007', 0.89, 32),
('ZH00004', '安全手套', 'AUTO008', 0.90, 32);

-- 보안경 / Safety Goggles (00005)
INSERT INTO terms (term_id, term_text, source_code, confidence_score, lookup_count) VALUES
('KO00005', '보안경', 'KOSHA005', 0.92, 28),
('EN00005', 'Safety Goggles', 'ANSI002', 0.95, 28),
('VI00005', 'Kính bảo hộ', 'AUTO009', 0.86, 28),
('ZH00005', '安全眼镜', 'AUTO010', 0.89, 28);

-- ============================================================
-- 건설장비 관련 용어 (00011-00020)
-- ============================================================

-- 중장비 / Heavy Equipment (00011)
INSERT INTO terms (term_id, term_text, source_code, confidence_score, lookup_count) VALUES
('KO00011', '중장비', 'KOSHA011', 0.94, 52),
('EN00011', 'Heavy Equipment', 'OSHA011', 0.96, 52),
('VI00011', 'Thiết bị hạng nặng', 'AUTO011', 0.85, 52),
('ZH00011', '重型设备', 'AUTO012', 0.88, 52);

-- 크레인 / Crane (00012)
INSERT INTO terms (term_id, term_text, source_code, confidence_score, lookup_count) VALUES
('KO00012', '크레인', 'OSHA012', 0.97, 48),
('EN00012', 'Crane', 'OSHA013', 0.98, 48),
('VI00012', 'Cần cẩu', 'AUTO013', 0.87, 48),
('ZH00012', '起重机', 'AUTO014', 0.91, 48);

-- 굴착기 / Excavator (00013)
INSERT INTO terms (term_id, term_text, source_code, confidence_score, lookup_count) VALUES
('KO00013', '굴착기', 'OSHA014', 0.95, 35),
('EN00013', 'Excavator', 'OSHA015', 0.97, 35),
('VI00013', 'Máy xúc', 'AUTO015', 0.88, 35),
('ZH00013', '挖掘机', 'AUTO016', 0.90, 35);

-- ============================================================
-- 번역 테스트 예시
-- ============================================================

-- 영어 "Crane"을 베트남어로 번역하는 쿼리:
-- SELECT 
--     source.term_text as 원문,
--     target.term_text as 번역문,
--     target.source_code as 출처
-- FROM terms source, terms target
-- WHERE source.term_text = 'Crane'
--   AND source.term_id LIKE 'EN%'
--   AND target.term_id = 'VI' || SUBSTR(source.term_id, 3);

-- ============================================================
-- 샘플 데이터 생성 완료
-- 총 13개 개념, 4개 언어 (KO, EN, VI, ZH) = 52개 레코드
-- ============================================================