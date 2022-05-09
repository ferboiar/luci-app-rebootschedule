m=Map("rebootschedule",translate("定时任务设置"),
"A plugin that makes scheduled tasks easier to use. You can use '-' to indicate a continuous time range, use ',' to indicate multiple time points, and use */ to indicate loop execution. You can use 'Add' to add multiple scheduled task commands. Additional parameters can be added '--custom--'.</br>" ..
" * All time parameters refer to the time point in the natural unit, not the cumulative count. For example, the week can only be 0 to 6, the hour can only be 0 to 23, the minute can only be 0 to 59.</br>" ..
" * All values can use '-' for a continuous range. Such as week: 1-5 means Monday to Friday; Use ',' for individual time points. For a week: 1,3,5 means only Monday, Wednesday, and Friday." ..
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


week=s:option(Value,"week",translate("Day of the week (0～6)"),
translate("<font color=\"gray\"></font>"))
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


hour=s:option(Value,"hour",translate("Hour (0～23)"),
translate("<font color=\"gray\">* means every hour, */n means every n hours</font>"))
hour.rmempty = false
hour.default = '5'

minute=s:option(Value,"minute",translate("Minute (0～59)"),
translate("<font color=\"gray\">* means every minute, */n means every n minutes</font>"))
minute.rmempty = false
minute.default = '0'

command=s:option(Value,"command",translate("Command (&& concatenate)"),
translate("<font color=\"gray\">Select "--custom--" to modify</br>(you can also add it to the scheduled task to modify)</font>"))
command:value('sync && echo 3 > /proc/sys/vm/drop_caches', translate("A.Free memory"))
command:value('sysfree.sh',translate("B.Clean up trash"))
command:value('sleep 5 && touch /etc/banner && reboot',translate("C.Reboot"))
command:value('poweroff',translate("D.Power off"))
command:value('/etc/init.d/ksmdb restart &&/etc/init.d/samba restart &&/etc/init.d/samba4 restart',translate("E.Restart SMB/Samba"))
command:value('/etc/init.d/network restart',translate("F.Restart network"))
command:value('ifdown wan && ifup wan',translate("G.Restart WAN interface"))
command:value('killall -q pppd && sleep 5 && pppd file /tmp/ppp/options.wan', translate("H.Redial (pppd)"))
command:value('ifdown wan',translate("I.Turn off WAN"))
command:value('ifup wan',translate("J.Turn on WAN"))
command:value('wifi down',translate("K.Turn off WiFi"))
command:value('wifi up',translate("L.Turn on WiFi"))
command.default='sleep 5 && touch /etc/banner && reboot'

local e=luci.http.formvalue("cbi.apply")
if e then
  io.popen("/etc/init.d/rebootschedule restart")
end

return m
