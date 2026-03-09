#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTRUCTIONS_SOURCE="$SCRIPT_DIR/instructions"
COPILOT_SOURCE="$SCRIPT_DIR/copilot-instructions.md"
PROJECT_DIR="$(pwd)"
TARGET_DIR="$PROJECT_DIR/.github/instructions"
TARGET_COPILOT="$PROJECT_DIR/.github/copilot-instructions.md"

show_list=false
uninstall=false
selected_skills=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --list)      show_list=true; shift ;;
        --uninstall) uninstall=true; shift ;;
        --skills)    selected_skills="$2"; shift 2 ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --list          Show available instructions"
            echo "  --skills LIST   Comma-separated instructions to install"
            echo "  --uninstall     Remove all sf-* instructions"
            echo "  -h, --help      Show this help"
            exit 0
            ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

all_instructions=($(ls "$INSTRUCTIONS_SOURCE"/sf-*.md 2>/dev/null | xargs -n1 basename | sed 's/\.md$//' | sort))

if $show_list; then
    echo ""
    echo "Available Salesforce Instructions (${#all_instructions[@]}):"
    echo "-------------------------------------------------------"
    for name in "${all_instructions[@]}"; do
        desc=$(awk '/^description:/{flag=1; sub(/^description: */, ""); print; next} flag && /^(applyWhen|----)/{exit} flag{print}' "$INSTRUCTIONS_SOURCE/$name.md" | head -1 | cut -c1-80)
        printf "  \033[32m%-40s\033[0m %s\n" "$name" "$desc"
    done
    echo ""
    exit 0
fi

if $uninstall; then
    echo ""
    echo "Uninstalling Salesforce instructions..."
    removed=0
    for name in "${all_instructions[@]}"; do
        target="$TARGET_DIR/$name.md"
        if [[ -f "$target" ]]; then
            rm -f "$target"
            echo "  Removed: $name.md"
            ((removed++))
        fi
    done
    [[ -f "$TARGET_COPILOT" ]] && rm -f "$TARGET_COPILOT" && echo "  Removed: copilot-instructions.md"
    if [[ $removed -eq 0 ]]; then
        echo "  No instructions found to remove."
    else
        echo ""
        echo "Removed $removed instruction(s)."
    fi
    exit 0
fi

instructions_to_install=("${all_instructions[@]}")
if [[ -n "$selected_skills" ]]; then
    IFS=',' read -ra instructions_to_install <<< "$selected_skills"
    for s in "${instructions_to_install[@]}"; do
        s=$(echo "$s" | xargs)
        if [[ ! " ${all_instructions[*]} " =~ " $s " ]]; then
            echo "Unknown instruction: $s"
            echo "Run $0 --list to see available instructions."
            exit 1
        fi
    done
fi

mkdir -p "$TARGET_DIR"

echo ""
echo "Installing ${#instructions_to_install[@]} instruction(s) to $TARGET_DIR ..."
installed=0
for name in "${instructions_to_install[@]}"; do
    name=$(echo "$name" | xargs)
    cp "$INSTRUCTIONS_SOURCE/$name.md" "$TARGET_DIR/$name.md"
    echo "  Installed: $name.md"
    ((installed++))
done

mkdir -p "$PROJECT_DIR/.github"
cp "$COPILOT_SOURCE" "$TARGET_COPILOT"
echo "  Installed: copilot-instructions.md"

echo ""
echo "Done! Installed $installed instruction(s) + global copilot-instructions.md."
echo ""
