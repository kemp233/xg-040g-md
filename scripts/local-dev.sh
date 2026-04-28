#!/bin/bash
set -euo pipefail

# 本地开发环境设置
setup_local_dev() {
    echo "=== 设置本地开发环境 ==="
    
    # 创建必要的目录
    mkdir -p build cache logs
    
    # 设置 Git 钩子
    setup_git_hooks
    
    # 检查依赖
    check_dependencies
    
    echo "✅ 本地开发环境设置完成"
}

# Git 钩子设置
setup_git_hooks() {
    echo "安装 Git 钩子..."
    
    # 预提交钩子
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
set -e

echo "=== 预提交检查 ==="

# 检查配置文件
if [ -f "scripts/check-config.sh" ]; then
    bash scripts/check-config.sh
fi

# 检查补丁文件
if [ -f "scripts/patch-manager.sh" ]; then
    bash scripts/patch-manager.sh check
fi

# 检查脚本语法
for script in scripts/*.sh; do
    if [ -f "$script" ] && [ -x "$script" ]; then
        bash -n "$script"
    fi
done

echo "✅ 预提交检查通过"
EOF

    chmod +x .git/hooks/pre-commit
    
    # 提交消息模板
    cat > .git/COMMIT_TEMPLATE << 'EOF'
# 提交说明

## 类型 (必需)
- feat: 新功能
- fix: 修复
- docs: 文档
- style: 格式
- refactor: 重构
- test: 测试
- chore: 其他

## 简要说明 (必需)
一句话描述本次提交

## 详细说明 (可选)
- 修改了什么
- 为什么修改
- 如何修改

## 相关 (可选)
- 相关 Issue: #123
- 相关 PR: #456

## 标记 (可选)
- [skip-build]: 跳过 CI 构建
- [quick-check]: 快速检查模式
EOF

    git config commit.template .git/COMMIT_TEMPLATE
}

# 检查依赖
check_dependencies() {
    local deps=("git" "bash" "make" "gcc")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            echo "❌ 依赖缺失: $dep"
            exit 1
        fi
    done
    echo "✅ 依赖检查通过"
}

# 智能提交
smart_commit() {
    echo "=== 智能提交 ==="
    
    # 检查是否有未提交的更改
    if [ -z "$(git status --porcelain)" ]; then
        echo "❌ 没有未提交的更改"
        exit 1
    fi
    
    # 运行预提交检查
    echo "运行预提交检查..."
    if ! bash scripts/pre-commit-check.sh; then
        echo "❌ 预提交检查失败，请修复问题后再提交"
        exit 1
    fi
    
    # 智能生成提交信息
    if [ $# -eq 0 ]; then
        # 分析变更生成提交信息
        local changed_files=$(git diff --name-only --cached)
        local commit_type="chore"
        
        if echo "$changed_files" | grep -q "config/"; then
            commit_type="feat"
        elif echo "$changed_files" | grep -q "patch/"; then
            commit_type="fix"
        elif echo "$changed_files" | grep -q "scripts/"; then
            commit_type="refactor"
        elif echo "$changed_files" | grep -q "docs/\|README"; then
            commit_type="docs"
        fi
        
        git commit -m "$commit_type: update files"
    else
        git commit -m "$1"
    fi
    
    echo "✅ 提交完成"
}

# 主函数
main() {
    case "${1:-help}" in
        setup)
            setup_local_dev
            ;;
        commit)
            shift
            smart_commit "$@"
            ;;
        check)
            check_dependencies
            ;;
        *)
            echo "Usage: $0 {setup|commit|check}"
            echo "  setup   - 设置本地开发环境"
            echo "  commit  - 智能提交"
            echo "  check   - 检查依赖"
            ;;
    esac
}

main "$@"
