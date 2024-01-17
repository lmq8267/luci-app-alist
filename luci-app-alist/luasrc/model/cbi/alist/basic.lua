local m, s

m = Map("alist", translate("Alist 文件列表"), translate("一款支持多种存储的目录文件列表程序。") .. "<br/>" .. [[<a href="https://alist.nn.ci/zh/guide/drivers/local.html" target="_blank">]] .. translate("用户文档") .. [[</a>]])

m:section(SimpleSection).template  = "alist/alist_status"

s = m:section(TypedSection, "alist")
s.addremove = false
s.anonymous = true

o = s:option(Flag, "enabled", translate("Enabled"))
o.rmempty = false

o = s:option(Value, "port", translate("端口"))
o.datatype = "and(port,min(1))"
o.rmempty = false
o.default = "5244"

o = s:option(Flag, "log", translate("启用日志"))
o.default = 1
o.rmempty = false

o = s:option(Flag, "ssl", translate("启用 SSL"))
o.rmempty=false

o = s:option(Value,"ssl_cert", translate("SSL cert"), translate("SSL 证书文件路径"))
o.datatype = "file"
o:depends("ssl", "1")

o = s:option(Value,"ssl_key", translate("SSL key"), translate("SSL 密钥文件路径"))
o.datatype = "file"
o:depends("ssl", "1")

o = s:option(Flag, "mysql", translate("启用 MySQL"))
o.rmempty=false

o = s:option(Value,"mysql_host", translate("主机"))
o.datatype = "string"
o:depends("mysql", "1")

o = s:option(Value,"mysql_port", translate("端口"))
o.datatype = "and(port,min(1))"
o.default = "3306"
o:depends("mysql", "1")

o = s:option(Value,"mysql_username", translate("用户名"))
o.datatype = "string"
o:depends("mysql", "1")

o = s:option(Value,"mysql_password", translate("密码"))
o.datatype = "string"
o.password = true
o:depends("mysql", "1")

o = s:option(Value,"mysql_database", translate("数据库名"))
o.datatype = "string"
o:depends("mysql", "1")

o = s:option(Flag, "allow_wan", translate("允许从外网访问"))
o.rmempty = false

o = s:option(Value, "site_url", translate("站点 URL"), translate("Web 被反向代理到二级目录时，必须填写该选项以确保 Web 正常工作。URL 结尾请勿携带 '/'"))
o.datatype = "string"

o = s:option(Value, "max_connections", translate("最大并发连接数"), translate("默认0不限制，低性能设备建议设置较低的并发数（10-20）"))
o.datatype = "and(uinteger,min(0))"
o.default = "0"
o.rmempty = false

o = s:option(Value, "token_expires_in", translate("登录有效期（小时）"),
	translate("设备登录的有效期内不需要重新登录"))
o.datatype = "and(uinteger,min(1))"
o.default = "48"
o.rmempty = false

o = s:option(Value, "delayed_start", translate("开机延时启动（秒）"))
o.datatype = "and(uinteger,min(0))"
o.default = "0"
o.rmempty = false

o = s:option(Value, "bin_dir", translate("程序路径"),
	translate("自定义alist的存放路径,确保填写完整的路径及alist名称，下载alist.ipk后解压出alist二进制文件上传<br>官方二进制程序：<a href='https://github.com/alist-org/alist/releases' target='_blank'>下载地址1</a>&nbsp;&nbsp;&nbsp;IPK安装包：<a href='https://mirrors.vsean.net/openwrt/releases/' target='_blank'>下载地址2</a>&nbsp;&nbsp;&nbsp;<a href='http://mirrors.cloud.tencent.com/lede/' target='_blank'>下载地址3</a>&nbsp;&nbsp;&nbsp;下载对应的版本对应的CPU架构解压"))
o.datatype = "string"
o.placeholder = "/usr/bin/alist"

o = s:option(Value, "data_dir", translate("数据目录"),
	translate("这是data配置文件的路径，若启动失败，请使用外置存储设备的路径"))
o.datatype = "string"
o.default = "/etc/alist"

o = s:option(Value, "temp_dir", translate("缓存目录"),
	translate("这是下载文件缓存的路径"))
o.datatype = "string"
o.default = "/tmp/alist"
o.rmempty = false

o = s:option(Button, "admin_info", translate("重置密码"))
o.rawhtml = true
o.template = "alist/admin_info"

return m
