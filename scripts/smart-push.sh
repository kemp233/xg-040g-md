#!/bin/bash
set -euo pipefail

# 智能推送工具
smart_push() {
    echo "=== 智能推送 ==="
    
    # 获取当前分支
    local current_branch=$(git branch --show-current)
    
    # 检查是否需要构建
    local skip_build=""
    local quick_check=""
    
    # 检查提交消息中是否有跳过标记
    if git log --oneline -1 | grep -q "\[skip-build\]"; then
        skip_build="[skip-build]"
    elif git log --oneline -1 | grep -q "\[quick-check\]"; then
        quick_check="[quick-check]"
    fi
    
    echo "当前分支: $current_branch"
    echo "跳过构建: ${skip_build:-否}"
    echo "快速检查: ${quick_check:-否}"
    
    # 显示变更摘要
    echo "=== 变更摘要 ==="
    git log --oneline origin/$current_branch..HEAD || echo "首次推送"
    git diff --stat origin/$current_branch..HEAD 2>/dev/null || git diff --stat HEAD
    
    # 确认推送
    read -p "确认推送? (y/N): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "❌ 推送取消"
        exit 1
    fi
    
    # 执行推送
    echo "🚀 开始推送..."
    git push origin $current_branch
    
    echo "✅ 推送完成"
    echo "📋 查看构建状态: https://github.com/$(git remote get-url origin | sed 's/.*github.com[:/]//' | sed 's/.git$//')/actions"
}

# 创建带标记的提交
commit_with_flag() {
    local flag="$1"
    local message="${2:-Update}"
    
    git commit -m "$message $flag"
    echo "✅ 提交创建完成，标记: $flag"
}

# 主函数
main() {
    case "${1:-push}" in
        push)
            smart_push
            ;;
        skip)
            commit_with_flag "[skip-build]" "$2"
            ;;
        quick)
            commit_with_flag "[quick-check]" "$2"
            ;;
        *)
            echo "Usage: $0 {push|skip [msg]|quick [msg]}"
            echo "  push     - 智能推送"
            echo "  skip     - 创建跳过构建的提交"
            echo "  quick    - 创建快速检查的提交"
            ;;
    esac
}

main "$@"
