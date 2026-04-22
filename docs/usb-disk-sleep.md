# USB 硬盘睡眠管理配置指南

本文档介绍如何在 XG-040G-MD OpenWRT 固件上配置 USB 硬盘的睡眠功能，以延长硬盘寿命并节省电力。

## 功能概述

固件集成了 USB 硬盘睡眠管理功能，主要包括：
- **hdparm**: 传统硬盘参数设置工具
- **sdparm**: SCSI 设备高级参数设置工具
- **hd-idle**: 硬盘休眠守护进程（推荐使用）

## 快速配置

### 方法一：使用 hd-idle（推荐）

hd-idle 是一个守护进程，自动检测硬盘空闲状态并使其进入睡眠。

#### 1. 配置 hd-idle

编辑 `/etc/config/hd-idle`：

```bash
config hd_idle 'global'
    option enable '1'
    option interval '300'  # 检测间隔（秒）
    option min_idle '600'  # 空闲时间（秒）后休眠
    option log_level '2'

config hd_idle_device 'sda'
    option device '/dev/sda'
    option enable '1'
    option spindown_time '120'  # 120秒后休眠
```

#### 2. 启动 hd-idle

```bash
# 测试配置
hd-idle -t

# 启动服务
/etc/init.d/hd-idle start

# 设置开机自启
/etc/init.d/hd-idle enable
```

### 方法二：使用 hdparm

hdparm 是传统的硬盘参数设置工具。

#### 1. 手动设置硬盘休眠

```bash
# 查看当前硬盘信息
hdparm -I /dev/sda

# 设置休眠超时（120秒）
hdparm -S 12 /dev/sda

# 立即休眠（如果支持）
hdparm -Y /dev/sda
```

#### 2. 常用参数说明

- `-S`: 设置自动休眠超时（0-253）
  - 0: 禁用自动休眠
  - 1-240: 超时时间 = 值 × 5 秒
  - 241-251: 超时时间 = (值-240) × 30 分钟
  - 252: 21 分钟
  - 253: 3 小时
  - 255: 禁用

- `-Y`: 使硬盘立即进入睡眠模式
- `-y`: 使硬盘进入低功率模式
- `-C`: 检查硬盘电源状态

### 方法三：使用 sdparm

sdparm 用于 SCSI/SATA 设备的高级参数设置。

#### 1. 查看设备信息

```bash
sdparm --inquiry /dev/sda
```

#### 2. 设置电源管理

```bash
# 查看当前电源管理设置
sdparm --get=PM /dev/sda

# 设置电源管理（0=禁用，1=启用）
sdparm --set=PM=1 /dev/sda
```

## 自动启动配置

### 创建自动休眠脚本

创建 `/etc/hotplug.d/block/10-usb-disk-sleep`：

```bash
#!/bin/sh

# 当 USB 硬盘插入时自动配置休眠
[ "$ACTION" = "add" ] && [ -n "$DEVNAME" ] || exit 0

# 等待设备初始化
sleep 2

# 检查是否为 USB 设备
if [ -d "/sys/block/$(basename $DEVNAME)/device/usb" ]; then
    # 使用 hd-idle 管理
    logger "USB disk $DEVNAME detected, enabling sleep management"
    
    # 或者手动设置（不推荐同时使用）
    # hdparm -S 12 $DEVNAME
fi
```

设置脚本权限：

```bash
chmod +x /etc/hotplug.d/block/10-usb-disk-sleep
```

## LuCI 界面配置

如果使用 LuCI 界面，可以安装相应的配置插件：

```bash
# 安装 LuCI 界面（如果可用）
# opkg update
# opkg install luci-app-hd-idle
```

然后在 **系统 > 硬盘管理** 中配置睡眠参数。

## 验证硬盘睡眠状态

### 1. 查看当前状态

```bash
# 检查硬盘是否支持休眠
hdparm -C /dev/sda

# 查看 hd-idle 状态
/etc/init.d/hd-idle status
```

### 2. 监控硬盘活动

```bash
# 查看硬盘 I/O 统计
iostat -x 1 | grep sda

# 监控硬盘状态
smartctl -i /dev/sda
```

### 3. 测试休眠功能

```bash
# 手动触发休眠
hdparm -Y /dev/sda

# 检查是否进入睡眠
hdparm -C /dev/sda | grep "standby"
```

## 高级配置

### 针对不同类型硬盘的配置

#### 机械硬盘（HDD）

```bash
# 更激进的休眠策略
hdparm -S 6 /dev/sda  # 30秒后休眠
hdparm -B 1 /dev/sda  # 最低功耗
```

#### 固态硬盘（SSD）

```bash
# SSD 不需要传统休眠，但可以启用 DevSleep
hdparm -S 0 /dev/sda  # 禁用自动休眠
```

#### 混合硬盘（SSHD）

```bash
# 平衡策略
hdparm -S 12 /dev/sda  # 60秒后休眠
```

### 多硬盘配置

编辑 `/etc/config/hd-idle` 为每个硬盘单独配置：

```bash
config hd_idle_device 'sda'
    option device '/dev/sda'
    option enable '1'
    option spindown_time '120'

config hd_idle_device 'sdb'
    option device '/dev/sdb'
    option enable '1'
    option spindown_time '180'
```

### 基于时间的休眠策略

创建 `/etc/crontabs/root` 定时任务：

```bash
# 每天凌晨2点强制休眠所有硬盘
0 2 * * * /usr/bin/hdparm -Y $(ls /dev/sd[a-z] 2>/dev/null)

# 每天早上6点唤醒硬盘（如果需要）
0 6 * * * /usr/bin/hdparm -C /dev/sda | grep -q "active" || echo "wakeup" > /dev/null
```

## 故障排除

### 问题: 硬盘无法休眠
**解决方案**:
1. 检查是否有进程占用硬盘: `fuser -m /mnt/usb`
2. 检查内核日志: `dmesg | grep sd`
3. 确认硬盘支持休眠: `hdparm -I /dev/sda | grep "standby"`
4. 尝试手动休眠: `hdparm -Y /dev/sda`

### 问题: 硬盘频繁唤醒
**解决方案**:
1. 增加休眠超时时间
2. 检查是否有定时任务访问硬盘
3. 禁用不必要的服务（如 Samba 扫描）
4. 检查 WebDAV 等服务的访问日志

### 问题: hd-idle 无法启动
**解决方案**:
1. 检查配置文件语法: `hd-idle -t`
2. 确认设备路径正确
3. 检查权限: `ls -l /dev/sda`
4. 查看错误日志: `logread | grep hd-idle`

### 问题: 硬盘唤醒后无法访问
**解决方案**:
1. 检查文件系统: `fsck /dev/sda1`
2. 重新挂载: `umount /mnt/usb && mount /mnt/usb`
3. 检查电源供应是否充足

## 性能优化

### 调整 I/O 调度器

```bash
# 查看当前调度器
cat /sys/block/sda/queue/scheduler

# 设置为 noop（适合 SSD）或 cfq（适合 HDD）
echo noop > /sys/block/sda/queue/scheduler
```

### 优化文件系统挂载选项

编辑 `/etc/config/fstab`：

```bash
config mount
    option device '/dev/sda1'
    option target '/mnt/usb'
    option fstype 'ext4'
    option options 'noatime,nodiratime,data=writeback'
    option enabled '1'
```

## 安全建议

1. **确保数据安全** - 在休眠前确保所有数据已写入
2. **避免频繁启停** - 设置合理的超时时间（建议 ≥ 5 分钟）
3. **监控硬盘健康** - 定期检查 S.M.A.R.T. 状态
4. **备份重要数据** - 防止硬盘故障导致数据丢失

## 参考命令速查

```bash
# 硬盘信息
hdparm -I /dev/sda
smartctl -i /dev/sda

# 电源状态
hdparm -C /dev/sda

# 设置休眠
hdparm -S 12 /dev/sda  # 60秒
hdparm -Y /dev/sda     # 立即休眠

# 监控 I/O
iostat -x 1
iotop

# 检查占用
fuser -m /mnt/usb
lsof | grep /mnt/usb
```

## 参考链接

- [OpenWRT hd-idle 文档](https://openwrt.org/packages/pkgdata/hd-idle)
- [hdparm 手册](https://linux.die.net/man/8/hdparm)
- [sdparm 手册](https://linux.die.net/man/8/sdparm)
- [USB 存储设备休眠最佳实践](https://www.kernel.org/doc/html/latest/admin-guide/usb-storage.html)