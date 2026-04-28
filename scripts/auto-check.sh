#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

source "$SCRIPT_DIR/check-config.sh"
source "$SCRIPT_DIR/patch-manager.sh"

echo "=== XG-040G-MD 自动化检查 ==="
echo "时间: $(date)"
echo "项目目录: $PROJECT_DIR"

# 运行所有检查
run_checks() {
    echo "🔍 1. 检查配置文件..."
    check_config
    
    echo "🔍 2. 检查补丁文件..."
    check_patches
    
    echo "🔍 3. 检查脚本语法..."
    for script in "$SCRIPT_DIR"/*.sh; do
        if [ -f "$script" ] && [ -x "$script" ]; then
            if bash -n "$script"; then
                echo "✅ $script 语法正常"
            else
                echo "❌ $script 语法错误"
                exit 1
            fi
        fi
    done
    
    echo "🔍 4. 检查 Git 状态..."
    if [ -d "$PROJECT_DIR/.git" ]; then
        cd "$PROJECT_DIR"
        git status --porcelain
        if [ $? -eq 0 ]; then
            echo "✅ Git 状态正常"
        else
            echo "❌ Git 状态异常"
            exit 1
        fi
    fi
    
    echo "🔍 5. 检查磁盘空间..."
    local free_space=$(df -BG "$PROJECT_DIR" | awk 'NR==2 {print $4}' | sed 's/G//')
    if [ "$free_space" -lt 10 ]; then
        echo "⚠️  磁盘空间不足: ${free_space}GB"
    else
        echo "✅ 磁盘空间充足: ${free_space}GB"
    fi
}

# 主函数
main() {
    run_checks
    
    echo ""
    echo "✅ 所有检查完成!"
    echo "建议操作:"
    echo "1. 提交更改: git add . && git commit -m '整理项目'"
    echo "2. 推送更新: git push origin main"
    echo "3. 测试构建: 在 GitHub Actions 中手动触发构建"
}

main "$@"
