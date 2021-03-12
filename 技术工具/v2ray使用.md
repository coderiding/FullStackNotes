# v2ray教程

## v2ray的辅助工具

- [v2rayX](https://github.com/Cenmrev/V2RayX/releases)
- [v2rayX配置指南](https://www.i5seo.com/v2ray-mac-use-the-tutorials-v2rayx.html)
- [vultr](https://www.vultr.com/)
- [v2ray-core](https://github.com/v2ray/v2ray-core/releases)
- [v2ray官网](https://www.v2ray.com/)

## 问题

1.搬瓦工ip地址被封了，无法通过ssh连接

- 我的解决办法：通过新开一个一个月的vps，然后登陆上去，通过这个vps去ssh那个被封的
- ssh的命令是



```
ssh -p 26325 root@174.137.53.x
```

# **一、在Cloudflare网站上的配置**

1.注册[Cloudflare](https://www.cloudflare.com/zh-cn/)

2.填写你的域名 

3.获取域名之前的信息，会得到你的域名的dns信息、该域名指向的ip地址，我之前的域名是用来给github博客用的，所以指向的是github的地址，这里我们要改成vps的ip地址。 

4.到域名的管理网站上面，修改默认的dns服务器为Cloudflare的dns地址，修改了，会有缓存，要等一段时间生效，一旦成功，会收到邮件，会发到你注册Cloudflare的邮箱上。 

5.dns地址修改成功后，到crypto里面把加密方式设置为full(strict)。 

6.到dns栏目，生成证书，这个证书的公钥和私钥要自己拷贝出来，做成两个文件，我是直接到vps服务器上，用命令创建这两个文件，把秘钥复制上去的。

# **二、在pc端上的操作**

1、安装v2ray 如果你是linux或者centos，就用下面的命令



```
bash <(curl -L -s https://install.direct/go.sh)
```

如果你是其他的，就到[v2ray-github网站](https://github.com/v2ray/v2ray-core/releases)上下载

下载后，需要修改v2ray的配置文件，配置的位置是：/etc/v2ray/config.json

配置的内容是：

```
{
  "inbounds": [{
    "port": 1080,
    "listen": "127.0.0.1",
    "protocol": "socks",
    "settings": {
      "udp": true
    }
  }],
  "outbounds": [{
    "protocol": "vmess",
    "settings": {
      "vnext": [{
        "address": "example.com(填写你自己的域名)",
        "port": 443,
        "users": [{ "id": "你自己在VPS服务端的ID",
                        "level": 1, "alterId": 64, "security": "auto"  }]
      }]
    },
    "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
            "serverName": "example.com(你自己的域名)",
            "allowInsecure": true
        },
        "wsSettings": {
            "path": "/ws"
        }
    },
    "mux": { "enabled": true }
  }, {
    "protocol": "freedom",
    "tag": "direct",
    "settings": {}
  }],
  "routing": {
    "domainStrategy": "IPOnDemand",
    "rules": [{
      "type": "field",
      "ip": ["geoip:private"],
      "outboundTag": "direct"
    }]
  }
}
```

2.启动v2ray

如果是linux或者centos，可以通过下面的命令



```
systemctl enable v2ray
systemctl start v2ray
```

3.自己去修改socks代理为127.0.0.1

我自己的是mac，就到系统配置，里面修改

# **三、在vps上的操作**

已准备好： 

a、你有一个域名 

b、要将域名的dns服务器改成Cloudflare网站里面指定的dns地址，因为默认的域名dns是那个域名运营商的，所以这里改改 

c、在Cloudflare网站上生成一个证书，证书有公钥和私钥，公钥的命名规则是 (域名.pem)，私钥的命名规则是 (域名.key) 

d、注意：这个vps是用centos来装的

1.安装apache服务器



```
yum install httpd -y
```

2.设置开机启动apache



```
systemctl enable httpd 
```

3.安装Apache ssl模块



```
yum install mod_ssl -y
```

4.配置vps上这个位置上的这个文件



```
/etc/httpd/conf.d/(域名.conf)文件
```

具体的配置内容是：

```
<VirtualHost *:80>
        Servername example.com(你自己的域名)
        RewriteEngine on
        RewriteCond %{SERVER_NAME} =example.com(你自己的域名)
        RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URL} [END,NE,R=permanent]
</VirtualHost>

<VirtualHost *:443>
        Servername example.com(你自己的域名)
        SSLEngine on
        SSLCertificateFile /etc/cloudflare/example.com(你自己的域名).pem
        SSLCertificateKeyFile /etc/cloudflare/example.com(你自己的域名).key
        RewriteEngine On
        RewriteCond %{HTTP:Upgrade} =websocket [NC]
        RewriteRule /(.*)      ws://localhost:12345/$1 [P,L]
        RewriteCond %{HTTP:Upgrade} !=websocket [NC]
        RewriteRule /(.*)      http://localhost:12345/$1 [P,L]
        SSLProxyEngine On
        ProxyPass /ws http://localhost:12345
        ProxyPassReverse /ws http://127.0.0.1:12345
</VirtualHost>
```

5.重启apache daemon



```
systemctl restart httpd
```

6.配置防火墙规则



```
firewall-cmd --permanent --add-service=https
firewall-cmd --reload
```

7.安装curl工具



```
yum install curl -y
```

8.安装v2ray



```
bash <(curl -L -s https://install.direct/go.sh)
```

9.设置开机启动v2ray daemon



```
systemctl enable v2ray
```

10.修改v2ray的配置文件



```
/etc/v2ray/config.json
```

配置的内容是：

```
{
  "inbounds": [{
    "port": 12345,
    "listen": "127.0.0.1",
    "protocol": "vmess",
    "settings": {
      "clients": [
        {
          "id": "你自己的ID", //此处不要修改
          "level": 1,
          "alterId": 64
        }
      ]
    },
    "streamSettings": {
        "network": "ws",
        "wsSettings": {
            "path": "/ws"
        }
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  },{
    "protocol": "blackhole",
    "settings": {},
    "tag": "blocked"
  }],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": ["geoip:private"],
        "outboundTag": "blocked"
      }
    ]
  }
}
```

11.重启v2ray daemon



```
systemctl restart v2ray
```

12.配置证书 路径是：

/etc/cloudflare/域名.pem

/etc/cloudflare/域名.key