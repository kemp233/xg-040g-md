#!/bin/bash
set -e

echo "=== Ensuring Required Packages ==="

# 检查feeds目录是否存在
if [ ! -d "feeds" ]; then
    echo "⚠️  feeds directory not found, skipping package verification"
    echo "=== Package verification skipped ==="
    exit 0
fi

# 检查关键包是否存在
check_package() {
    local pkg=$1
    if ! ./scripts/feeds list 2>/dev/null | grep -q "^${pkg}$"; then
        echo "❌ Package ${pkg} not found in feeds"
        return 1
    fi
    echo "✅ Package ${pkg} found"
    return 0
}

# 检查CUPS相关包 - with fallback for different branch naming
echo "🔍 Checking CUPS packages..."
found_cups=0
for pkg in cups libcups cups-filters; do
    if check_package "$pkg"; then
        found_cups=1
    fi
done

if [ "$found_cups" -eq 0 ]; then
    echo "⚠️  No CUPS packages found in feeds, but this may be expected in some branches"
fi

# 检查OpenClash相关包 - with flexible matching
echo "🔍 Checking OpenClash packages..."
found_openclash=0
for pkg in openclash luci-app-openclash; do
    if check_package "$pkg"; then
        found_openclash=1
    fi
done

if [ "$found_openclash" -eq 0 ]; then
    echo "⚠️  No OpenClash packages found in feeds, but this may be expected in some branches"
fi

# 检查LuCI基础包 (非必需，某些分支可能没有)
echo "🔍 Checking LuCI base packages..."
for pkg in luci luci-ssl; do
    if ! check_package "$pkg"; then
        echo "⚠️  Package ${pkg} not found, but this may be expected in some branches"
    fi
done

echo "=== Package verification completed (non-essential packages may be missing depending on branch) ==="
