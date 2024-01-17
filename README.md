# luci-app-alist

项目地址：https://github.com/cloudflare/cloudflared

此luci-app-alist复制于https://github.com/kiddin9/openwrt-packages/tree/master/luci-app-alist

没有添加alist二进制程序，需要自己下载对应cpu架构的二进制程序手动上传至路由器，然后填写对应的程序路径。不能直接下载alist.ipk直接安装！
像7621cpu的路由器，数据目录设置在/etc/alist 会启动不了，出现这样的情况，可以设置数据目录在外置存储设备里可以解决。


### UI预览 ###

![](./Image/界面.png)
