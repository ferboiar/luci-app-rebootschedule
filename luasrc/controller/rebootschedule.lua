module("luci.controller.rebootschedule", package.seeall)
function index()
	if not nixio.fs.access("/etc/config/rebootschedule") then
		return
	end
	
	entry({"admin", "control"}, firstchild(), "Control", 44).dependent = false
	entry({"admin", "control", "rebootschedule"}, cbi("rebootschedule"), "Timing Setting", 20).dependent = true
end



