#!/bin/bash
set -euo pipefail

CONFIG_FILE="config/xg-040g-md.config"

echo "=== OpenWRT 配置检查 ==="

# 检查重复配置
echo "🔍 检查重复配置项:"
if grep -o '^CONFIG_[^=]*=' "$CONFIG_FILE" | sort | uniq -d; then
    echo "❌ 发现重复配置!"
    exit 1
else
    echo "✅ 无重复配置"
fi

# 检查必要配置
essential_configs=(
    "CONFIG_TARGET_airoha"
    "CONFIG_TARGET_airoha_an7581" 
    "CONFIG_TARGET_airoha_an7581_DEVICE_bell_xg-040g-md"
    "CONFIG_DEFAULT_base-files"
    "CONFIG_DEFAULT_busybox"
    "CONFIG_PACKAGE_dnsmasq"
    "CONFIG_PACKAGE_luci-app-homeproxy"
    "CONFIG_PACKAGE_luci-app-passwall"
)

echo "🔍 检查必要配置:"
for config in "${essential_configs[@]}"; do
    if grep -q "^${config}=y" "$CONFIG_FILE"; then
        echo "✅ $config"
    else
        echo "❌ $config 缺失!"
    fi
done

echo "✅ 配置检查完成"
