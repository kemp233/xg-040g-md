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

## 新增故障记录 - 2026-05-01T14:50:53.443Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T14:50:55.083Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T14:50:56.306Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T14:55:04.510Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T14:55:04.658Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T14:55:04.777Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T14:55:05.049Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T14:55:05.710Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:00:04.722Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:00:04.823Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:00:04.837Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:00:05.093Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:00:05.124Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:05:04.385Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:05:04.766Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:05:05.113Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:05:05.418Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:05:05.615Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:10:04.862Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:10:04.895Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:10:05.237Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:10:05.268Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:10:06.729Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:15:04.343Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:15:04.690Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:15:04.714Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:15:04.741Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:15:05.118Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:20:04.046Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:20:04.280Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:20:04.524Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:20:04.637Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:20:04.820Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:25:04.509Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:25:04.647Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:25:04.715Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:25:05.957Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:25:07.060Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:30:04.315Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:30:04.323Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:30:04.640Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:30:04.745Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:30:06.271Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:35:05.599Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:35:05.849Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:35:06.004Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:35:06.385Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:35:06.955Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:40:05.412Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:40:05.695Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:40:06.313Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:40:06.516Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:40:07.640Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:45:06.527Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:45:07.245Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:45:07.789Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:45:07.855Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---


## 新增故障记录 - 2026-05-01T15:45:13.499Z

### 错误类型: config_order_error
**错误特征**: Configuration file order error
**修复方法**: Adjust workflow step order
**修复效果**: 待验证
**备注**: 自动修复已应用

---

