# XG-040G-MD OpenWRT 构建指南

## 环境要求
- Ubuntu 20.04+ 或 Debian 10+
- 至少 20GB 可用空间
- 安装依赖包:
  ```bash
  sudo apt update
  sudo apt install -y build-essential clang flex bison g++ gawk \
    gcc-multilib g++-multilib gettext git libncurses5-dev libssl-dev \
    python3-setuptools rsync swig unzip zlib1g-dev file wget \
    mkbootimg device-tree-compiler ccache
  ```

## 快速构建
```bash
# 克隆源码
git clone --depth 1 --branch openwrt-25.12 https://github.com/xiangtailiang/openwrt.git openwrt

# 复制配置
cp config/xg-040g-md.config openwrt/.config

# 更新 feeds
cd openwrt
./scripts/feeds update -a
./scripts/feeds install -a -f

# 更新第三方包
bash ../scripts/update-packages.sh

# 构建固件
make -j$(nproc)  # 或使用 make -j1 V=s 查看详细日志
```

## 常见问题
- **构建失败**: 检查依赖是否完整，清理缓存后重试
- **下载失败**: 可能需要科学上网
- **刷机问题**: 参考 README.md 中的刷机教程
