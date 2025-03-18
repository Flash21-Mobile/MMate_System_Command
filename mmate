#!/bin/bash

MMATE_DIR="mmate_system"
PACKAGES=("core" "function" "design")  # mmate_system 내부 패키지 리스트
ERRORS=()  # 오류 메시지를 저장할 배열
LOG_FILE="temp.log"  # Flutter pub get 로그 저장 파일

# 색상 정의
GREEN='\033[32m'  # 초록색
RED='\033[31m'    # 빨간색
RESET='\033[0m'   # 리셋

MMATE_DIR="mmate_system"
REPO_URL="https://github.com/Flash21-Mobile/MMate_System.git"

# 로딩 애니메이션 함수
show_spinner() {
    local pid=$1
    local delay=0.1
    local spin_chars=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')

    tput civis # 커서 숨기기
    while ps -p $pid > /dev/null; do
        for i in "${spin_chars[@]}"; do
            printf "\r%s Processing..." "$i"
            sleep $delay
        done
    done
    tput cnorm # 커서 다시 표시
    printf "\r\033[K" # ✅ 로딩 애니메이션 메시지 삭제
}

case "$1" in

init)
    echo "🚀 Initializing MMate System..."

    # GitHub에서 리포지토리 클론
    DEST_DIR="$MMATE_DIR"

    if [ -d "$DEST_DIR" ]; then
        echo -e "${RED}[✘] '$DEST_DIR' already exists. Please delete it before running 'mmate init' again.${RESET}"
        exit 1
    fi

    # git clone 중간 메시지 숨기기
    echo -e "${GREEN}[✓] Cloning MMate System repository from $REPO_URL into '$DEST_DIR'...${RESET}"
    git clone $REPO_URL $DEST_DIR > /dev/null 2>&1 &

    show_spinner $! # 로딩 애니메이션
    wait $!

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[✓] Successfully cloned MMate_System into '$DEST_DIR' directory.${RESET}"
    else
        echo -e "${RED}[✘] Failed to clone the MMate_System repository.${RESET}"
    fi
    ;;


    pub)
        case "$2" in
            get)
                echo "🚀 Running 'flutter pub get' in the current package and all sub-packages..."

                # 1️⃣ 현재 디렉토리에서 실행
                if [ -f "pubspec.yaml" ]; then
                    flutter pub get --suppress-analytics > "$LOG_FILE" 2>&1 &
                    show_spinner $! # 로딩 애니메이션
                    wait $!

                    if [ $? -ne 0 ]; then
                        ERRORS+=("${RED}[✘] Current package - Failed to fetch dependencies.${RESET}")
                    else
                        echo -e "${GREEN}[✓] Current package - Successfully fetched dependencies.${RESET}"
                    fi
                fi

                # 2️⃣ mmate_system 내부의 모든 패키지에서 실행
                if [ ! -d "$MMATE_DIR" ]; then
                    echo -e "${RED}[✘] MMate System directory '$MMATE_DIR' does not exist. Run 'mmate init' first.${RESET}"
                    exit 1
                fi

                for package in "${PACKAGES[@]}"; do
                    PACKAGE_PATH="$MMATE_DIR/$package"

                    if [ -d "$PACKAGE_PATH" ]; then
                        flutter pub get --suppress-analytics > "$LOG_FILE" 2>&1 &
                        show_spinner $! # 로딩 애니메이션
                        wait $!

                        if [ $? -ne 0 ]; then
                            ERRORS+=("${RED}[✘] '$package' - Failed to fetch dependencies.${RESET}")
                        else
                            echo -e "${GREEN}[✓] '$package' - Successfully fetched dependencies.${RESET}"
                        fi
                    else
                        echo -e "${RED}[✘] '$package' does not exist inside '$MMATE_DIR'. Skipping...${RESET}"
                    fi
                done

                # ✅ 모든 작업이 끝난 후 Flutter pub get 로그 삭제
                rm -f "$LOG_FILE"

                echo "🎉 All tasks completed."

                # 오류 메시지가 있으면 출력
                if [ ${#ERRORS[@]} -ne 0 ]; then
                    echo -e "${RED}⚠️  Some errors occurred during execution:${RESET}"
                    for error in "${ERRORS[@]}"; do
                        echo "   $error"
                    done
                    exit 1
                fi
                ;;
            
            *)
                echo -e "${RED}[✘] Unknown subcommand: '$2'. Use 'mmate pub get'.${RESET}"
                ;;
        esac
        ;;
        
    upgrade)
        echo "🚀 Upgrading MMate System..."

        # mmate_system 디렉토리로 이동
        if [ ! -d "$MMATE_DIR" ]; then
            echo -e "${RED}[✘] MMate System directory '$MMATE_DIR' does not exist. Run 'mmate init' first.${RESET}"
            exit 1
        fi

        cd "$MMATE_DIR" || exit

        # 변경 사항이 있는지 확인하고 최신 커밋으로 동기화
        git fetch origin
        LOCAL=$(git rev-parse @)
        REMOTE=$(git rev-parse @{u})

        if [ $LOCAL = $REMOTE ]; then
            echo -e "${GREEN}[✓] Your MMate System is up to date.${RESET}"
        else
            echo -e "${GREEN}[✓] Updating MMate System to the latest version...${RESET}"
            git pull origin main  # 최신 상태로 pull
            echo -e "${GREEN}[✓] Successfully updated MMate System.${RESET}"
        fi

        # 원래 디렉토리로 돌아오기
        cd - || exit
        ;;
        
    update)
        echo "🚀 Updating and pushing changes in MMate System..."

        # mmate_system 디렉토리로 이동
        if [ ! -d "$MMATE_DIR" ]; then
            echo -e "${RED}[✘] MMate System directory '$MMATE_DIR' does not exist. Run 'mmate init' first.${RESET}"
            exit 1
        fi

        cd "$MMATE_DIR" || exit

        # 변경 사항 확인
        if ! git diff-index --quiet HEAD --; then
            echo -e "${GREEN}[✓] Changes detected, preparing to commit and push...${RESET}"

            # 변경 사항 커밋
            git add . > /dev/null 2>&1
            git commit -m "Updated MMate System" > /dev/null 2>&1 &

            show_spinner $! # 로딩 애니메이션
            wait $!

            if [ $? -eq 0 ]; then
                # 변경 사항 푸시
                git push origin main > /dev/null 2>&1 &

                show_spinner $! # 로딩 애니메이션
                wait $!

                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}[✓] Pushed changes to remote repository.${RESET}"
                else
                    echo -e "${RED}[✘] Failed to push changes to remote repository.${RESET}"
                fi
            else
                echo -e "${RED}[✘] No changes to commit.${RESET}"
            fi
        else
            echo -e "${GREEN}[✓] No changes detected in MMate System.${RESET}"
        fi

        # 원래 디렉토리로 돌아오기 (출력 숨기기)
        cd - > /dev/null || exit
        ;;
        
    *)
        echo -e "${RED}[✘] Unknown command: '$1'. Available commands: init, pub get.${RESET}"
        exit 1
        ;;
esac
