module("luci.controller.alist", package.seeall)

function index()
	entry({"admin", "nas"}, firstchild(), _("NAS") , 45).dependent = false
	if not nixio.fs.access("/etc/config/alist") then
		return
	end

	local page = entry({"admin", "nas", "alist"}, alias("admin", "nas", "alist", "basic"), _("Alist"), 20)
	page.dependent = true
	page.acl_depends = { "luci-app-alist" }

	entry({"admin", "nas"}, firstchild(), "NAS", 44).dependent = false
	entry({"admin", "nas", "alist", "basic"}, cbi("alist/basic"), _("基本设置"), 1).leaf = true
	entry({"admin", "nas", "alist", "log"}, cbi("alist/log"), _("日志"), 2).leaf = true
	entry({"admin", "nas", "alist", "alist_status"}, call("alist_status")).leaf = true
	entry({"admin", "nas", "alist", "get_log"}, call("get_log")).leaf = true
	entry({"admin", "nas", "alist", "clear_log"}, call("clear_log")).leaf = true
	entry({"admin", "nas", "alist", "admin_info"}, call("admin_info")).leaf = true
end

function alist_status()
	local e={}
          local sys  = require "luci.sys"
	local uci  = require "luci.model.uci".cursor()
	local port = tonumber(uci:get_first("alist", "alist", "port"))
                   e.port = (port or 5244)
		e.running=luci.sys.call("pidof alist >/dev/null")==0
	
         local command1 = io.popen("[ -f /tmp/alist_time ] && start_time=$(cat /tmp/alist_time) && time=$(($(date +%s)-start_time)) && day=$((time/86400)) && [ $day -eq 0 ] && day='' || day=${day}天 && time=$(date -u -d @${time} +'%H小时%M分%S秒') && echo $day $time")
                   e.alista = command1:read("*all")
                   command1:close()
                   if e.alista == "" then
                   e.alista = "unknown"
                   end
  
         local command2 = io.popen('test ! -z "`pidof alist`" && (top -b -n1 | grep -E "$(pidof alist)" 2>/dev/null | grep -v grep | awk \'{for (i=1;i<=NF;i++) {if ($i ~ /alist/) break; else cpu=i}} END {print $cpu}\')')
                   e.alicpu = command2:read("*all")
                   command2:close()
                   if e.alicpu == "" then
                   e.alicpu = "unknown"
                   end
  
         local command3 = io.popen("test ! -z `pidof alist` && (cat /proc/$(pidof alist | awk '{print $NF}')/status | grep -w VmRSS | awk '{printf \"%.2f MB\", $2/1024}')")
                   e.aliram = command3:read("*all")
                   command3:close()
                   if e.aliram == "" then
                   e.aliram = "unknown"
                   end
  
         local command4 = io.popen("([ -s /tmp/alist.tag ] && cat /tmp/alist.tag ) || (echo `$(uci -q get alist.@alist[0].bin_dir) version | head -n -1 |awk -F 'Version:' '{print v$2}'| sed 's/[^0-9.]*//g'` > /tmp/alist.tag && cat /tmp/alist.tag)")
                   e.alitag = command4:read("*all")
                   command4:close()
                   if e.alitag == "" then
                   e.alitag = "unknown"
                   end
  
         local command5 = io.popen("([ -s /tmp/alistnew.tag ] && cat /tmp/alistnew.tag ) || ( curl -L -k -s --connect-timeout 3 --user-agent 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36' https://api.github.com/repos/alist-org/alist/releases/latest | grep tag_name | sed 's/[^0-9.]*//g' >/tmp/alistnew.tag && cat /tmp/alistnew.tag )")
                   e.alistnewtag = command5:read("*all")
                   command5:close()
                   if e.alistnewtag == "" then
                   e.alistnewtag = "unknown"
                   end
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end

function get_log()
	luci.http.write(luci.sys.exec("test ! -z `pidof alist` && cat $(uci -q get alist.@alist[0].temp_dir)/alist.log"))
end

function clear_log()
	luci.sys.call("cat /dev/null > $(uci -q get alist.@alist[0].temp_dir)/alist.log")
end

function admin_info()
	local random = luci.sys.exec("$(uci -q get alist.@alist[0].bin_dir) --data $(uci -q get alist.@alist[0].data_dir) admin set admin 2>&1")
	local username = string.match(random, "新用户名： (%S+)")
	local password = string.match(random, "新密码： (%S+)")

	luci.http.prepare_content("application/json")
	luci.http.write_json({username = username, password = password})
end
