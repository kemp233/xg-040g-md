#!/bin/bash
set -euo pipefail

echo "=== 预提交检查 ==="

# 运行配置检查
if [ -f "scripts/check-config.sh" ]; then
    echo "🔍 检查配置文件..."
    bash scripts/check-config.sh
fi

# 运行补丁检查
if [ -f "scripts/patch-manager.sh" ]; then
    echo "🔍 检查补丁文件..."
    bash scripts/patch-manager.sh check
fi

# 检查脚本语法
for script in scripts/*.sh; do
    if [ -f "$script" ] && [ -x "$script" ]; then
        echo "🔍 检查脚本: $script"
        bash -n "$script" || exit 1
    fi
done

# 检查 YAML 语法
for yaml in .github/workflows/*.yml; do
    if [ -f "$yaml" ]; then
        echo "🔍 检查 YAML: $yaml"
        python3 -c "import yaml; yaml.safe_load(open('$yaml'))" || exit 1
    fi
done

echo "✅ 预提交检查通过"
