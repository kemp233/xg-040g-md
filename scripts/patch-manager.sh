#!/bin/bash
set -euo pipefail

PATCH_DIR="patch"
BACKUP_DIR="patch-backup-$(date +%Y%m%d)"

log_info() { echo "[INFO] $1"; }
log_warn() { echo "[WARN] $1"; }
log_error() { echo "[ERROR] $1"; }

# 备份补丁
backup_patches() {
    log_info "备份补丁文件..."
    mkdir -p "$BACKUP_DIR"
    cp -r "$PATCH_DIR"/* "$BACKUP_DIR/"
    log_info "补丁已备份到 $BACKUP_DIR"
}

# 检查补丁状态
check_patches() {
    log_info "检查补丁文件..."
    
    # 检查补丁格式
    for patch in "$PATCH_DIR"/*.patch; do
        if [ -f "$patch" ]; then
            if head -n 5 "$patch" | grep -q "^---"; then
                echo "✅ $patch 格式正常"
            else
                echo "❌ $patch 格式可能有问题"
            fi
        fi
    done
    
    # 检查设备树文件
    for dts in "$PATCH_DIR"/*.dts; do
        if [ -f "$dts" ]; then
            if dtc -I dts -O dtb -o /dev/null "$dts" 2>/dev/null; then
                echo "✅ $dts 语法正常"
            else
                echo "❌ $dts 语法错误"
            fi
        fi
    done
}

# 主函数
main() {
    case "${1:-help}" in
        backup)
            backup_patches
            ;;
        check)
            check_patches
            ;;
        *)
            echo "Usage: $0 {backup|check}"
            exit 1
            ;;
    esac
}

main "$@"
