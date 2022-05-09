m=Map("rebootschedule",translate("定时任务设置"),
"A plugin that makes scheduled tasks easier to use. You can use '-' to indicate a continuous time range, use ',' to indicate multiple time points, and use */ to indicate loop execution. You can use 'Add' to add multiple scheduled task commands. Additional parameters can be added '--custom--'.</br></br>" ..
"* All time parameters refer to the time point in the natural unit, not the cumulative count. For example, the week can only be 0 to 6, the hour can only be 0 to 23, the minute can only be 0 to 59.</br>" ..
"* All values can use '-' for a continuous range. Such as week: 1-5 means Monday to Friday; Use ',' for individual time points. For a week: 1,3,5 means only Monday, Wednesday, and Friday." ..
translate("&nbsp;&nbsp;&nbsp;<input class=\"cbi-button cbi-button-apply\" type=\"button\" value=\"" ..
translate("查看/验证") ..
" \" onclick=\"window.open('http://www.cronmaker.com/?1')\"/>")
)

s=m:section(TypedSection,"crontab","")
s.anonymous = true
s.addremove = true
s.sortable = false
s.template = "cbi/tblsection"
s.rmempty = false

p=s:option(Flag,"enable",translate("启用"))
p.rmempty = false
p.default=0


week=s:option(Value,"week",translate("星期 (数值范围0～6)"),
translate("<font color=\"gray\">和日期是逻辑“与”关系</br>n1-n5连续，n1,n3,n5不连续</font>"))
week.rmempty = true
week:value('*',translate("每天"))
week:value(0,translate("Sunday"))
week:value(1,translate("Monday"))
week:value(2,translate("Tuesday"))
week:value(3,translate("Wednesday"))
week:value(4,translate("Thursday"))
week:value(5,translate("Friday"))
week:value(6,translate("Saturday"))
week.default='*'


hour=s:option(Value,"hour",translate("时 (数值范围0～23)"),
translate("<font color=\"gray\">*表示每小时，*/n表示每n小时</br>n1-n5连续，n1,n3,n5不连续</font>"))
hour.rmempty = false
hour.default = '5'

minute=s:option(Value,"minute",translate("分 (数值范围0～59)"),
translate("<font color=\"gray\">*表示每分钟，*/n表示每n分钟</br>n1-n5连续，n1,n3,n5不连续</font>"))
minute.rmempty = false
minute.default = '0'

command=s:option(Value,"command",translate("执行命令 (多条用 && 连接)"),
translate("<font color=\"gray\">按“--自定义--”可进行修改</br>(亦可添加后到计划任务中修改)</font>"))
command:value('sync && echo 3 > /proc/sys/vm/drop_caches', translate("A.释放内存"))
command:value('sysfree.sh',translate("B.清理垃圾"))
command:value('sleep 5 && touch /etc/banner && reboot',translate("C.重启系统"))
command:value('poweroff',translate("D.关闭电源"))
command:value('/etc/init.d/ksmdb restart &&/etc/init.d/samba restart',translate("E.重启共享"))
command:value('/etc/init.d/network restart',translate("F.重启网络"))
command:value('ifdown wan && ifup wan',translate("G.重启WAN"))
command:value('killall -q pppd && sleep 5 && pppd file /tmp/ppp/options.wan', translate("H.重新拨号"))
command:value('ifdown wan',translate("I.关闭联网"))
command:value('ifup wan',translate("J.打开联网"))
command:value('wifi down',translate("K.关闭WIFI"))
command:value('wifi up',translate("L.打开WIFI"))
command.default='sleep 5 && touch /etc/banner && reboot'

local e=luci.http.formvalue("cbi.apply")
if e then
  io.popen("/etc/init.d/rebootschedule restart")
end

return m
