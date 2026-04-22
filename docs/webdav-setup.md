# WebDAV 服务器配置指南

本文档介绍如何在 XG-040G-MD OpenWRT 固件上配置和使用 WebDAV 服务器。

## 功能概述

固件已集成 lighttpd WebDAV 服务器，提供以下功能：
- 基于 HTTP/HTTPS 的文件访问
- 支持 WebDAV 标准协议（RFC 4918）
- 与 Windows、macOS、Linux 及移动端兼容
- 支持身份验证

## 快速配置

### 1. 创建 WebDAV 数据目录

首先，在 USB 存储或 overlay 分区上创建 WebDAV 数据目录：

```bash
# 挂载 USB 存储（如果尚未挂载）
mkdir -p /mnt/usb
mount /dev/sda1 /mnt/usb

# 创建 WebDAV 数据目录
mkdir -p /mnt/usb/webdav
mkdir -p /mnt/usb/webdav/data
mkdir -p /mnt/usb/webdav/backup
```

### 2. 配置 lighttpd

编辑 `/etc/lighttpd/lighttpd.conf`，添加或修改以下配置：

```bash
# 启用必要的模块
server.modules += ("mod_webdav", "mod_auth", "mod_alias", "mod_rewrite")

# WebDAV 配置
$HTTP["host"] == "webdav.local" {
    server.document-root = "/mnt/usb/webdav/data"
    
    # 身份验证配置
    auth.backend = "plain"
    auth.backend.plain.userfile = "/etc/lighttpd/webdav.passwd"
    auth.require = ( "/" => 
        (
            "method" => "basic",
            "realm" => "WebDAV Storage",
            "require" => "valid-user"
        )
    )
    
    # WebDAV 权限配置
    webdav.allowed-methods = ("GET", "HEAD", "POST", "PUT", "DELETE", "MKCOL", "PROPFIND", "PROPPATCH", "COPY", "MOVE", "LOCK", "UNLOCK")
    webdav.is-enabled = "enable"
}
```

### 3. 创建用户密码文件

创建 WebDAV 用户并设置密码：

```bash
# 创建密码文件（第一个用户）
echo "username:$(echo -n 'username' | md5sum | cut -d' ' -f1):WebDAV Storage" > /etc/lighttpd/webdav.passwd

# 添加更多用户（使用不同用户名）
echo "user2:$(echo -n 'user2' | md5sum | cut -d' ' -f1):WebDAV Storage" >> /etc/lighttpd/webdav.passwd
```

**注意**: 上述方法使用 MD5 密码。对于生产环境，建议使用更安全的密码哈希方法。

### 4. 设置目录权限

确保 lighttpd 进程有访问权限：

```bash
chown -R nobody:nogroup /mnt/usb/webdav
chmod -R 755 /mnt/usb/webdav
```

### 5. 启动服务

```bash
# 测试配置文件
lighttpd -t -f /etc/lighttpd/lighttpd.conf

# 启动 lighttpd
/etc/init.d/lighttpd start

# 设置开机自启
/etc/init.d/lighttpd enable
```

## 访问方式

### Windows
1. 打开"此电脑"
2. 右键"映射网络驱动器"
3. 输入 URL: `http://<router-ip>:8080/` 或 `https://<router-ip>:8443/`
4. 输入用户名和密码

### macOS
1. 打开 Finder
2. 按 Cmd+K 打开"连接服务器"
3. 输入: `http://<router-ip>:8080/` 或 `https://<router-ip>:8443/`
4. 输入用户名和密码

### Linux (命令行)
```bash
# 使用 cadaver 客户端
cadaver http://<router-ip>:8080/

# 或挂载为文件系统
davfs2 http://<router-ip>:8080/ /mnt/webdav
```

### 移动端
- **iOS**: 使用 Files 应用，添加 WebDAV 服务器
- **Android**: 使用 Solid Explorer、Cx File Explorer 等支持 WebDAV 的文件管理器

## HTTPS 配置（推荐）

为了安全，建议配置 HTTPS：

### 1. 生成自签名证书

```bash
# 生成私钥
openssl genrsa -out /etc/lighttpd/server.key 2048

# 生成证书签名请求
openssl req -new -key /etc/lighttpd/server.key -out /etc/lighttpd/server.csr

# 生成自签名证书
openssl x509 -req -days 365 -in /etc/lighttpd/server.csr -signkey /etc/lighttpd/server.key -out /etc/lighttpd/server.crt
```

### 2. 配置 lighttpd 使用 SSL

```bash
# 启用 SSL 模块
server.modules += ("mod_openssl")

# HTTPS 配置
$HTTP["host"] == "webdav.local" {
    $SERVER["socket"] == ":8443" {
        ssl.engine = "enable"
        ssl.pemfile = "/etc/lighttpd/server.crt"
        ssl.privkey = "/etc/lighttpd/server.key"
    }
}
```

## 高级配置

### 配置多个 WebDAV 存储位置

```bash
# 主存储
$HTTP["url"] =~ "^/webdav1" {
    server.document-root = "/mnt/usb/webdav/data1"
    alias.url = ( "/webdav1" => "/mnt/usb/webdav/data1" )
}

# 备份存储
$HTTP["url"] =~ "^/webdav2" {
    server.document-root = "/mnt/usb/webdav/data2"
    alias.url = ( "/webdav2" => "/mnt/usb/webdav/data2" )
}
```

### 限制访问 IP 地址

```bash
$HTTP["host"] == "webdav.local" {
    $HTTP["remoteip"] != "192.168.1.0/24" {
        url.access-deny = ( "" )
    }
}
```

### 启用日志

```bash
server.errorlog = "/var/log/lighttpd/error.log"
accesslog.filename = "/var/log/lighttpd/access.log"
```

## 故障排除

### 问题: 无法访问 WebDAV
**解决方案**:
1. 检查 lighttpd 是否运行: `ps | grep lighttpd`
2. 检查端口监听: `netstat -tuln | grep 8080`
3. 检查配置文件: `lighttpd -t -f /etc/lighttpd/lighttpd.conf`
4. 检查防火墙设置

### 问题: 认证失败
**解决方案**:
1. 检查密码文件格式
2. 确保用户文件权限正确: `chmod 600 /etc/lighttpd/webdav.passwd`
3. 检查 realm 名称是否匹配

### 问题: 权限不足
**解决方案**:
1. 检查目录所有权: `chown -R nobody:nogroup /path/to/webdav`
2. 检查目录权限: `chmod -R 755 /path/to/webdav`

## 性能优化

### 启用 gzip 压缩

```bash
server.modules += ("mod_compress")
compress.filetype = ("text/plain", "text/html", "text/css", "application/javascript")
```

### 调整缓存设置

```bash
server.max-keep-alive-idle = 5
server.max-worker = 4
```

## 安全建议

1. **始终使用 HTTPS** - 避免在公网使用 HTTP
2. **使用强密码** - 定期更换密码
3. **限制访问 IP** - 只允许可信网络访问
4. **定期备份数据** - 防止数据丢失
5. **保持系统更新** - 及时应用安全补丁

## 参考链接

- [OpenWRT lighttpd 文档](https://openwrt.org/packages/pkgdata/lighttpd)
- [WebDAV RFC 4918](https://tools.ietf.org/html/rfc4918)
- [lighttpd WebDAV 模块文档](https://redmine.lighttpd.net/projects/lighttpd/wiki/Docs_ModWebDAV)
