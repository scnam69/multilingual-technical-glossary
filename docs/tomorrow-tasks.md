# 🚀 내일 작업 계획 (2025-06-30)

> **작업 목표**: 전체 CSV 데이터를 SQLite로 일괄 가져오기  
> **예상 소요시간**: 30분 ~ 1시간  
> **난이도**: ⭐⭐☆☆☆ (중급)

## 📋 작업 전 체크리스트

### 환경 확인
- [ ] 터미널 열기
- [ ] 프로젝트 폴더로 이동: `cd ~/multilingual-glossary`
- [ ] 파일 확인: `ls -la` (4개 파일 있어야 함)

### 필요한 파일들 확인
```bash
# 이 명령어로 확인
ls -la

# 예상 결과:
# Glos_OSHA_all.xlsx    (131KB)
# glossary.csv          (184KB) 
# real_glossary.db      (12KB)
# test.db               (8KB)
```

---

## 🎯 1단계: 확장된 데이터베이스 스키마 생성

### Step 1-1: 새로운 완전 데이터베이스 생성

```bash
# 터미널에서 실행
sqlite3 complete_glossary.db
```

### Step 1-2: 22개 언어 지원 테이블 생성

```sql
-- SQLite 프롬프트에서 실행
CREATE TABLE terms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    term_id TEXT UNIQUE,
    korean TEXT,
    korean_desc TEXT,
    source TEXT,
    english TEXT,
    vietnamese TEXT,
    chinese TEXT,
    russian TEXT,
    khmer TEXT,
    nepali TEXT,
    indonesian TEXT,
    thai TEXT,
    burmese TEXT,
    mongolian TEXT,
    sinhala TEXT,
    tamil TEXT,
    bengali TEXT,
    urdu TEXT,
    portuguese TEXT,
    lao TEXT,
    kazakh TEXT,
    ukrainian TEXT,
    filipino TEXT,
    uzbek TEXT,
    turkish TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Step 1-3: 테이블 생성 확인

```sql
-- 테이블 구조 확인
.schema terms

-- SQLite 종료
.quit
```

---

## 🔧 2단계: Python 데이터 가져오기 스크립트 작성

### Step 2-1: 스크립트 폴더 생성

```bash
# 터미널에서 실행
mkdir tools
cd tools
```

### Step 2-2: Python 스크립트 파일 생성

```bash
# 텍스트 에디터로 파일 생성 (VS Code, nano, vim 등)
# 파일명: csv_import.py
```

### Step 2-3: Python 스크립트 내용

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
엑셀/CSV 데이터를 SQLite 데이터베이스로 가져오는 스크립트
파일: tools/csv_import.py
"""

import csv
import sqlite3
import sys
import os

def import_csv_to_sqlite():
    """
    CSV 파일을 SQLite 데이터베이스로 가져오기
    """
    
    # 파일 경로 설정
    csv_file = '../glossary.csv'
    db_file = '../complete_glossary.db'
    
    # 파일 존재 확인
    if not os.path.exists(csv_file):
        print(f"❌ 오류: {csv_file} 파일을 찾을 수 없습니다.")
        return False
    
    try:
        # SQLite 연결
        conn = sqlite3.connect(db_file)
        cursor = conn.cursor()
        
        # CSV 파일 읽기
        with open(csv_file, 'r', encoding='utf-8') as file:
            csv_reader = csv.reader(file)
            
            # 헤더 읽기 (첫 번째 행)
            headers = next(csv_reader)
            print(f"📋 헤더 확인: {len(headers)}개 컬럼")
            print(f"📋 언어 컬럼: {headers[:25]}...")  # 처음 25개만 표시
            
            # 데이터 삽입 준비
            insert_count = 0
            error_count = 0
            
            # 각 행 처리
            for row_num, row in enumerate(csv_reader, start=2):
                try:
                    # term_id 생성 (5자리 0패딩)
                    term_id = f"{row_num-1:05d}"
                    
                    # 데이터 매핑 (CSV 컬럼 순서대로)
                    if len(row) >= 24:  # 최소 24개 컬럼 확인
                        cursor.execute("""
                            INSERT OR REPLACE INTO terms (
                                term_id, korean, korean_desc, source,
                                english, vietnamese, chinese, russian,
                                khmer, nepali, indonesian, thai,
                                burmese, mongolian, sinhala, tamil,
                                bengali, urdu, portuguese, lao,
                                kazakh, ukrainian, filipino, uzbek, turkish
                            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                        """, (
                            term_id,
                            row[0] if len(row) > 0 else '',   # 한국어(KO)
                            row[1] if len(row) > 1 else '',   # 한글 설명
                            row[2] if len(row) > 2 else '',   # 표준출처
                            row[3] if len(row) > 3 else '',   # 영어(EN)
                            row[4] if len(row) > 4 else '',   # 베트남어(VI)
                            row[5] if len(row) > 5 else '',   # 중국어(ZH)
                            row[6] if len(row) > 6 else '',   # 러시아어(RU)
                            row[7] if len(row) > 7 else '',   # 크메르어(KM)
                            row[8] if len(row) > 8 else '',   # 네팔어(NE)
                            row[9] if len(row) > 9 else '',   # 인도네시아어(ID)
                            row[10] if len(row) > 10 else '', # 태국어(TH)
                            row[11] if len(row) > 11 else '', # 버마어(MY)
                            row[12] if len(row) > 12 else '', # 몽골어(MN)
                            row[13] if len(row) > 13 else '', # 싱할라어(SI)
                            row[14] if len(row) > 14 else '', # 타밀어(TA)
                            row[15] if len(row) > 15 else '', # 벵골어(BN)
                            row[16] if len(row) > 16 else '', # 우르두어(UR)
                            row[17] if len(row) > 17 else '', # 포르투갈어(PT)
                            row[18] if len(row) > 18 else '', # 라오어(LO)
                            row[19] if len(row) > 19 else '', # 카자흐어(KK)
                            row[20] if len(row) > 20 else '', # 우크라이나어(UK)
                            row[21] if len(row) > 21 else '', # 필리핀어(TGL)
                            row[22] if len(row) > 22 else '', # 우즈베크어(UZ)
                            row[23] if len(row) > 23 else ''  # 튀르크어(TR)
                        ))
                        
                        insert_count += 1
                        
                        # 진행상황 표시 (10개마다)
                        if insert_count % 10 == 0:
                            print(f"📊 진행중... {insert_count}개 용어 처리 완료")
                    
                except Exception as e:
                    error_count += 1
                    print(f"⚠️  {row_num}행 처리 오류: {str(e)[:50]}...")
                    continue
            
            # 변경사항 저장
            conn.commit()
            
            # 결과 출력
            print(f"\n🎉 데이터 가져오기 완료!")
            print(f"📊 총 처리: {insert_count}개 용어")
            print(f"❌ 오류: {error_count}개")
            print(f"📁 데이터베이스: {db_file}")
            
            return True
            
    except Exception as e:
        print(f"❌ 치명적 오류: {e}")
        return False
        
    finally:
        if 'conn' in locals():
            conn.close()

def verify_import():
    """
    가져온 데이터 검증
    """
    db_file = '../complete_glossary.db'
    
    try:
        conn = sqlite3.connect(db_file)
        cursor = conn.cursor()
        
        # 총 레코드 수 확인
        cursor.execute("SELECT COUNT(*) FROM terms")
        total_count = cursor.fetchone()[0]
        print(f"\n📊 총 용어 수: {total_count}개")
        
        # 샘플 데이터 확인
        cursor.execute("SELECT korean, english, vietnamese FROM terms LIMIT 5")
        samples = cursor.fetchall()
        
        print(f"\n📝 샘플 데이터:")
        for i, (ko, en, vi) in enumerate(samples, 1):
            print(f"  {i}. {ko} → {en} → {vi}")
        
        # 번역 테스트
        test_terms = ['중장비', '크레인', '안전모']
        print(f"\n🔍 번역 테스트:")
        
        for term in test_terms:
            cursor.execute("SELECT english, vietnamese, chinese FROM terms WHERE korean = ?", (term,))
            result = cursor.fetchone()
            if result:
                en, vi, zh = result
                print(f"  {term} → EN:{en} | VI:{vi} | ZH:{zh}")
            else:
                print(f"  {term} → ❌ 찾을 수 없음")
        
        conn.close()
        return True
        
    except Exception as e:
        print(f"❌ 검증 오류: {e}")
        return False

if __name__ == "__main__":
    print("🚀 다국어 용어집 데이터 가져오기 시작\n")
    
    # 1단계: 데이터 가져오기
    if import_csv_to_sqlite():
        print("\n✅ 1단계 완료: 데이터 가져오기 성공")
        
        # 2단계: 데이터 검증
        if verify_import():
            print("\n✅ 2단계 완료: 데이터 검증 성공")
            print("\n🎉 모든 작업이 성공적으로 완료되었습니다!")
            print("\n💡 다음 단계: 웹 인터페이스 구축 또는 MCP 연동")
        else:
            print("\n❌ 2단계 실패: 데이터 검증 오류")
    else:
        print("\n❌ 1단계 실패: 데이터 가져오기 오류")
```

---

## ▶️ 3단계: 스크립트 실행

### Step 3-1: Python 실행

```bash
# tools 폴더에서 실행
python3 csv_import.py
```

### Step 3-2: 예상 출력 결과

```
🚀 다국어 용어집 데이터 가져오기 시작

📋 헤더 확인: 27개 컬럼
📋 언어 컬럼: ['한국어(KO)', '한글 설명', '표준출처', '영어(EN)', ...]
📊 진행중... 10개 용어 처리 완료
📊 진행중... 20개 용어 처리 완료
...
📊 진행중... 220개 용어 처리 완료

🎉 데이터 가져오기 완료!
📊 총 처리: 226개 용어
❌ 오류: 0개
📁 데이터베이스: ../complete_glossary.db

✅ 1단계 완료: 데이터 가져오기 성공

📊 총 용어 수: 226개

📝 샘플 데이터:
  1. 중장비 → Heavy equipment → Thiết bị hạng nặng
  2. 크레인 → Crane → Cần cẩu
  3. 굴착기 → Excavator → Máy xúc
  4. 덤프트럭 → Dump truck → Xe ben
  5. 콘크리트 믹서 → Concrete mixer → Máy trộn bê tông

🔍 번역 테스트:
  중장비 → EN:Heavy equipment | VI:Thiết bị hạng nặng | ZH:重型设备
  크레인 → EN:Crane | VI:Cần cẩu | ZH:起重机
  안전모 → EN:Safety helmet | VI:Mũ bảo hộ | ZH:安全帽

✅ 2단계 완료: 데이터 검증 성공

🎉 모든 작업이 성공적으로 완료되었습니다!

💡 다음 단계: 웹 인터페이스 구축 또는 MCP 연동
```

---

## ✅ 4단계: 완성 확인 및 테스트

### Step 4-1: 최종 파일 확인

```bash
# 프로젝트 루트로 돌아가기
cd ..

# 파일 목록 확인
ls -la

# 예상 결과: complete_glossary.db 파일이 추가됨
```

### Step 4-2: 수동 번역 테스트

```bash
# 새 데이터베이스 접속
sqlite3 complete_glossary.db
```

```sql
-- 총 용어 수 확인
SELECT COUNT(*) FROM terms;

-- 랜덤 번역 테스트
SELECT korean, english, vietnamese, chinese, russian 
FROM terms 
WHERE korean IN ('안전모', '크레인', '고소작업');

-- 언어별 데이터 현황
SELECT 
    COUNT(*) as 총용어수,
    COUNT(english) as 영어완성,
    COUNT(vietnamese) as 베트남어완성,
    COUNT(chinese) as 중국어완성
FROM terms;

-- SQLite 종료
.quit
```

---

## 🏆 성공 기준

### ✅ 완료 체크리스트
- [ ] `complete_glossary.db` 파일 생성됨
- [ ] 226개 용어 모두 가져오기 완료
- [ ] 22개 언어 데이터 정상 저장
- [ ] 번역 테스트 성공 (최소 3개 용어)
- [ ] 에러 없이 전체 프로세스 완료

### 🎯 예상 결과
- **데이터베이스 크기**: 약 500KB ~ 1MB
- **처리 속도**: 226개 용어 처리에 1~2분
- **번역 속도**: 즉시 응답 (0.01초)
- **지원 언어**: 22개 언어 완전 지원

---

## 🚨 문제 해결 가이드

### 자주 발생하는 문제들

**1. 인코딩 오류**
```
해결: CSV 파일을 UTF-8로 다시 저장
```

**2. Python 실행 오류**
```bash
# Python 버전 확인
python3 --version

# 권한 오류시
chmod +x tools/csv_import.py
```

**3. SQLite 연결 오류**
```bash
# 데이터베이스 파일 권한 확인
ls -la *.db

# 파일 삭제 후 재생성
rm complete_glossary.db
```

**4. 스크립트 오류**
```bash
# 단계별 디버그 실행
python3 -c "import csv; print('CSV 모듈 OK')"
python3 -c "import sqlite3; print('SQLite 모듈 OK')"
```

---

## 🎉 완료 후 다음 단계

### 즉시 사용 가능한 기능들

**터미널에서 번역 테스트**:
```bash
sqlite3 complete_glossary.db "SELECT english FROM terms WHERE korean = '안전모'"
# 결과: Safety helmet

sqlite3 complete_glossary.db "SELECT vietnamese FROM terms WHERE english = 'Crane'"
# 결과: Cần cẩu
```

**모든 언어로 번역 보기**:
```bash
sqlite3 complete_glossary.db "SELECT * FROM terms WHERE korean = '크레인'"
```

### 선택적 추가 작업

1. **웹 인터페이스 구축** (+1~2시간)
2. **모바일 앱 연동** (+3~4시간)
3. **MCP & Claude 연동** (+2~3시간)

---

**🎯 내일 이 작업을 완료하면:**
- ✅ 22개 언어 완전 지원 번역 시스템 ✅
- ✅ 226개 건설안전 전문용어 데이터베이스 ✅
- ✅ 즉시 실용 가능한 번역 도구 ✅

**정말 대단한 성과가 될 것입니다!** 🚀👏