#!/bin/bash
set -e

echo "=== Ensuring Required Packages ==="

# 首先更新feeds
echo "🔄 Updating feeds..."
./scripts/feeds update -a
./scripts/feeds install -a -f

# 检查关键包是否存在（支持多种名称）
check_package() {
    local pkg=$1
    if ! ./scripts/feeds list | grep -q "^${pkg}$"; then
        echo "❌ Package ${pkg} not found in feeds"
        return 1
    fi
    echo "✅ Package ${pkg} found"
    return 0
}

# 检查CUPS相关包（尝试多种名称）
echo "🔍 Checking CUPS packages..."
found_cups=0
for pkg in cups cups-server cups-client libcups cups-filters; do
    if check_package "$pkg"; then
        found_cups=1
    fi
done

if [ "$found_cups" -eq 0 ]; then
    echo "⚠️  No CUPS packages found in feeds, but this may be expected in some branches"
fi

# 检查OpenClash相关包（尝试多种名称）
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

# 检查LuCI基础包（必需）
echo "🔍 Checking LuCI base packages..."
found_luci=0
for pkg in luci luci-ssl luci-base; do
    if check_package "$pkg"; then
        found_luci=1
    fi
done

if [ "$found_luci" -eq 0 ]; then
    echo "❌ Essential LuCI packages not found!"
    exit 1
fi

echo "=== Package verification completed ==="
