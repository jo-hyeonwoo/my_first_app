#!/bin/bash

echo "🔧 GitHub 인증 정보 완전히 삭제 중..."

# 1. Keychain에서 GitHub 관련 모든 항목 삭제
echo "1. Keychain에서 GitHub 인증 정보 삭제..."
security delete-internet-password -s github.com 2>/dev/null || true

# 2. Git credential helper에서 삭제
echo "2. Git credential helper 정리..."
printf "host=github.com\nprotocol=https\n" | git credential-osxkeychain erase 2>/dev/null || true

# 3. 모든 GitHub 계정 정보 찾기 및 삭제
echo "3. 추가 인증 정보 확인 중..."
ACCOUNTS=$(security find-internet-password -s github.com 2>&1 | grep "acct" | sed 's/.*"acct"<blob>="\(.*\)"/\1/')

if [ ! -z "$ACCOUNTS" ]; then
    echo "   발견된 계정: $ACCOUNTS"
    for account in $ACCOUNTS; do
        echo "   계정 '$account' 삭제 중..."
        security delete-internet-password -s github.com -a "$account" 2>/dev/null || true
    done
else
    echo "   추가 인증 정보 없음"
fi

# 4. Git 설정 확인
echo ""
echo "✅ 현재 Git 설정:"
echo "   사용자 이름: $(git config --global user.name)"
echo "   이메일: $(git config --global user.email)"
echo ""
echo "🎯 다음 단계:"
echo "1. GitHub Personal Access Token 생성: https://github.com/settings/tokens"
echo "2. 'Generate new token (classic)' 클릭"
echo "3. 'repo' 권한 선택 후 생성"
echo "4. 생성된 토큰을 복사"
echo "5. 아래 명령어로 푸시:"
echo "   git push -u origin main"
echo "   (Username: jo-hyeonwoo, Password: 생성한 토큰)"
echo ""

