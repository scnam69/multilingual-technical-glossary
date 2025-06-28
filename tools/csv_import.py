#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
다국어 기술용어집 CSV 가져오기 도구
CSV 데이터를 SQLite 데이터베이스로 완전 변환하는 스크립트

파일: tools/csv_import.py
작성일: 2025-06-29
작성자: Sangchul Nam
목적: 235개 건설안전 용어 × 22개 언어 → SQLite 완전 변환
"""

import csv
import sqlite3
import sys
import os
from datetime import datetime

def import_csv_to_sqlite():
    """
    CSV 파일을 SQLite 데이터베이스로 가져오기
    
    Returns:
        bool: 성공 시 True, 실패 시 False
    """
    
    # 파일 경로 설정
    csv_file = '../glossary.csv'
    db_file = '../complete_glossary.db'
    
    print("🚀 다국어 용어집 데이터 가져오기 시작\n")
    
    # 파일 존재 확인
    if not os.path.exists(csv_file):
        print(f"❌ 오류: {csv_file} 파일을 찾을 수 없습니다.")
        return False
    
    try:
        # SQLite 연결
        conn = sqlite3.connect(db_file)
        cursor = conn.cursor()
        
        print(f"📁 데이터베이스 연결: {db_file}")
        
        # CSV 파일 읽기
        with open(csv_file, 'r', encoding='utf-8') as file:
            csv_reader = csv.reader(file)
            
            # 헤더 읽기 (첫 번째 행)
            headers = next(csv_reader)
            print(f"📋 헤더 확인: {len(headers)}개 컬럼")
            print(f"📋 처음 10개 컬럼: {headers[:10]}")
            
            # 데이터 삽입 준비
            insert_count = 0
            error_count = 0
            
            print(f"\n📊 데이터 처리 시작...")
            
            # 각 행 처리
            for row_num, row in enumerate(csv_reader, start=2):
                try:
                    # term_id 생성 (5자리 0패딩)
                    term_id = f"{row_num-1:05d}"
                    
                    # 데이터 매핑 (CSV 컬럼 순서대로)
                    if len(row) >= 24:  # 최소 24개 컬럼 확인
                        cursor.execute("""
                            INSERT OR REPLACE INTO terms (
                                term_id, description_ko, term_ko, source_ko,
                                term_en, source_en, term_vi, source_vi,
                                term_zh, source_zh, term_ru, source_ru,
                                term_km, source_km, term_ne, source_ne,
                                term_id_indo, source_id_indo, term_th, source_th,
                                term_my, source_my, term_mn, source_mn,
                                term_si, source_si, term_ta, source_ta,
                                term_bn, source_bn, term_ur, source_ur,
                                term_pt, source_pt, term_lo, source_lo,
                                term_kk, source_kk, term_uk, source_uk,
                                term_tg, source_tg, term_uz, source_uz,
                                term_tr, source_tr
                            ) VALUES (
                                ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 
                                ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 
                                ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 
                                ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
                            )
                        """, (
                            term_id,                                    # term_id
                            row[1] if len(row) > 1 else '',            # description_ko (한글 설명)
                            row[0] if len(row) > 0 else '',            # term_ko (한국어)
                            row[2] if len(row) > 2 else 'User_Select', # source_ko (한국어 출처)
                            row[3] if len(row) > 3 else '',            # term_en (영어)
                            'User_Select',                              # source_en
                            row[4] if len(row) > 4 else '',            # term_vi (베트남어)
                            'User_Select',                              # source_vi
                            row[5] if len(row) > 5 else '',            # term_zh (중국어)
                            'User_Select',                              # source_zh
                            row[6] if len(row) > 6 else '',            # term_ru (러시아어)
                            'User_Select',                              # source_ru
                            row[7] if len(row) > 7 else '',            # term_km (크메르어)
                            'User_Select',                              # source_km
                            row[8] if len(row) > 8 else '',            # term_ne (네팔어)
                            'User_Select',                              # source_ne
                            row[9] if len(row) > 9 else '',            # term_id_indo (인도네시아어)
                            'User_Select',                              # source_id_indo
                            row[10] if len(row) > 10 else '',          # term_th (태국어)
                            'User_Select',                              # source_th
                            row[11] if len(row) > 11 else '',          # term_my (버마어)
                            'User_Select',                              # source_my
                            row[12] if len(row) > 12 else '',          # term_mn (몽골어)
                            'User_Select',                              # source_mn
                            row[13] if len(row) > 13 else '',          # term_si (싱할라어)
                            'User_Select',                              # source_si
                            row[14] if len(row) > 14 else '',          # term_ta (타밀어)
                            'User_Select',                              # source_ta
                            row[15] if len(row) > 15 else '',          # term_bn (벵골어)
                            'User_Select',                              # source_bn
                            row[16] if len(row) > 16 else '',          # term_ur (우르두어)
                            'User_Select',                              # source_ur
                            row[17] if len(row) > 17 else '',          # term_pt (포르투갈어)
                            'User_Select',                              # source_pt
                            row[18] if len(row) > 18 else '',          # term_lo (라오어)
                            'User_Select',                              # source_lo
                            row[19] if len(row) > 19 else '',          # term_kk (카자흐어)
                            'User_Select',                              # source_kk
                            row[20] if len(row) > 20 else '',          # term_uk (우크라이나어)
                            'User_Select',                              # source_uk
                            row[21] if len(row) > 21 else '',          # term_tg (필리핀어)
                            'User_Select',                              # source_tg
                            row[22] if len(row) > 22 else '',          # term_uz (우즈베크어)
                            'User_Select',                              # source_uz
                            row[23] if len(row) > 23 else '',          # term_tr (터키어)
                            'User_Select'                               # source_tr
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
        print(f"💾 처리 시간: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        
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
    
    Returns:
        bool: 검증 성공 시 True, 실패 시 False
    """
    db_file = '../complete_glossary.db'
    
    try:
        conn = sqlite3.connect(db_file)
        cursor = conn.cursor()
        
        print(f"\n🔍 데이터 검증 시작...")
        
        # 총 레코드 수 확인
        cursor.execute("SELECT COUNT(*) FROM terms")
        total_count = cursor.fetchone()[0]
        print(f"📊 총 용어 수: {total_count}개")
        
        # 언어별 완성도 확인
        cursor.execute("""
            SELECT 
                COUNT(*) as total,
                COUNT(CASE WHEN term_ko != '' THEN 1 END) as korean,
                COUNT(CASE WHEN term_en != '' THEN 1 END) as english,
                COUNT(CASE WHEN term_vi != '' THEN 1 END) as vietnamese,
                COUNT(CASE WHEN term_zh != '' THEN 1 END) as chinese,
                COUNT(CASE WHEN term_ru != '' THEN 1 END) as russian
            FROM terms
        """)
        
        stats = cursor.fetchone()
        total, korean, english, vietnamese, chinese, russian = stats
        
        print(f"\n📈 언어별 완성도:")
        print(f"  한국어: {korean}/{total} ({korean*100//total}%)")
        print(f"  영어: {english}/{total} ({english*100//total}%)")
        print(f"  베트남어: {vietnamese}/{total} ({vietnamese*100//total}%)")
        print(f"  중국어: {chinese}/{total} ({chinese*100//total}%)")
        print(f"  러시아어: {russian}/{total} ({russian*100//total}%)")
        
        # 샘플 데이터 확인
        cursor.execute("SELECT term_ko, term_en, term_vi, term_zh FROM terms LIMIT 5")
        samples = cursor.fetchall()
        
        print(f"\n📝 샘플 데이터:")
        for i, (ko, en, vi, zh) in enumerate(samples, 1):
            print(f"  {i}. {ko} → {en} → {vi} → {zh}")
        
        # 번역 테스트
        test_terms = ['중장비', '크레인', '안전모']
        print(f"\n🔍 번역 테스트:")
        
        for term in test_terms:
            cursor.execute("""
                SELECT term_en, term_vi, term_zh 
                FROM terms WHERE term_ko = ?
            """, (term,))
            result = cursor.fetchone()
            if result:
                en, vi, zh = result
                print(f"  {term} → EN:{en} | VI:{vi} | ZH:{zh}")
            else:
                print(f"  {term} → ❌ 찾을 수 없음")
        
        # 출처 분포 확인
        cursor.execute("""
            SELECT source_ko, COUNT(*) as count 
            FROM terms 
            WHERE source_ko IS NOT NULL 
            GROUP BY source_ko 
            ORDER BY count DESC 
            LIMIT 5
        """)
        
        sources = cursor.fetchall()
        print(f"\n📚 주요 출처:")
        for source, count in sources:
            print(f"  {source}: {count}개 용어")
        
        conn.close()
        return True
        
    except Exception as e:
        print(f"❌ 검증 오류: {e}")
        return False

def display_usage_examples():
    """
    사용 예시 출력
    """
    print(f"\n💡 사용 예시:")
    print(f"")
    print(f"1. 터미널에서 번역 테스트:")
    print(f"   sqlite3 ../complete_glossary.db \"SELECT term_en FROM terms WHERE term_ko = '안전모'\"")
    print(f"")
    print(f"2. 다국어 번역:")
    print(f"   sqlite3 ../complete_glossary.db \"SELECT term_ko, term_en, term_vi, term_zh FROM terms WHERE term_ko = '크레인'\"")
    print(f"")
    print(f"3. 키워드 검색:")
    print(f"   sqlite3 ../complete_glossary.db \"SELECT term_ko, term_en FROM terms WHERE term_ko LIKE '%안전%'\"")
    print(f"")
    print(f"4. 전체 통계:")
    print(f"   sqlite3 ../complete_glossary.db \"SELECT COUNT(*) FROM terms\"")

def main():
    """
    메인 실행 함수
    """
    print("=" * 60)
    print("🌍 다국어 기술용어집 CSV Import 도구")
    print("   235개 건설안전 용어 × 22개 언어")
    print("   '생명을 구하는 번역' 프로젝트")
    print("=" * 60)
    
    # 1단계: 데이터 가져오기
    print("\n🚀 1단계: CSV 데이터 가져오기")
    if import_csv_to_sqlite():
        print("✅ 1단계 완료: 데이터 가져오기 성공")
        
        # 2단계: 데이터 검증
        print("\n🔍 2단계: 데이터 검증")
        if verify_import():
            print("✅ 2단계 완료: 데이터 검증 성공")
            
            # 3단계: 사용 예시 안내
            display_usage_examples()
            
            print("\n🎉 모든 작업이 성공적으로 완료되었습니다!")
            print("\n💡 다음 단계:")
            print("   - 웹 인터페이스 구축")
            print("   - MCP 연동으로 Claude와 실시간 번역")
            print("   - Safety-Training 프로젝트와 통합")
            
        else:
            print("❌ 2단계 실패: 데이터 검증 오류")
            return False
    else:
        print("❌ 1단계 실패: 데이터 가져오기 오류")
        return False
    
    return True

if __name__ == "__main__":
    """
    스크립트 직접 실행 시 메인 함수 호출
    
    사용법:
        cd ~/multilingual-glossary/tools
        python3 csv_import.py
    """
    try:
        success = main()
        if success:
            print(f"\n🎯 프로그램이 성공적으로 완료되었습니다!")
            sys.exit(0)
        else:
            print(f"\n❌ 프로그램 실행 중 오류가 발생했습니다.")
            sys.exit(1)
            
    except KeyboardInterrupt:
        print(f"\n\n⚠️  사용자에 의해 중단되었습니다.")
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ 예상치 못한 오류: {e}")
        sys.exit(1)