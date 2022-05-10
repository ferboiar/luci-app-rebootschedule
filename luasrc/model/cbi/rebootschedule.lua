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


week=s:option(Value,"week","Day of the week (0～6)","<font color=\"gray\">0 means Sunday,</br>6 means Saturday</font>")
week.rmempty = true
week:value('*',translate("每天"))
week:value(0,"Sunday")
week:value(1,"Monday")
week:value(2,"Tuesday")
week:value(3,"Wednesday")
week:value(4,"Thursday")
week:value(5,"Friday")
week:value(6,"Saturday")
week.default='*'


hour=s:option(Value,"hour","Hour (0～23)","<font color=\"gray\">* means every hour,</br>*/n means every n hours</font>")
hour.rmempty = false
hour.default = '5'

minute=s:option(Value,"minute","Minute (0～59)","<font color=\"gray\">* means every minute,</br>*/n means every n minutes</font>")
minute.rmempty = false
minute.default = '0'

command=s:option(Value,"command","Command (&& concatenate)","<font color=\"gray\">Select '--custom--' to modify</br>(you can also add it to the scheduled task to modify)</font>")
command:value('sync && echo 3 > /proc/sys/vm/drop_caches', "A. Free memory")
command:value('sysfree.sh',"B. Clean up trash")
command:value('sleep 5 && touch /etc/banner && reboot',"C. Reboot")
command:value('poweroff',"D. Power off")
command:value('/etc/init.d/ksmdb restart &&/etc/init.d/samba restart &&/etc/init.d/samba4 restart',"E. Restart SMB/Samba")
command:value('/etc/init.d/network restart',"F. Restart network")
command:value('ifdown wan && ifup wan',"G. Restart WAN interface")
command:value('killall -q pppd && sleep 5 && pppd file /tmp/ppp/options.wan', "H. Redial (pppd)")
command:value('ifdown wan',"I. Turn off WAN")
command:value('ifup wan',"J. Turn on WAN")
command:value('wifi down',"K. Turn off WiFi")
command:value('wifi up',"L. Turn on WiFi")
command.default='sleep 5 && touch /etc/banner && reboot'

local e=luci.http.formvalue("cbi.apply")
if e then
  io.popen("/etc/init.d/rebootschedule restart")
end

return m
