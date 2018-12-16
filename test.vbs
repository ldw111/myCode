Set WshShell = Wscript.CreateObject("Wscript.Shell")
WshShell.AppActivate ""
for i = 1 to 5
Wscript.Sleep 2000
'WshShell.sendKeys "^v"
WshShell.sendKeys "ifconfig eth0 172.18.13.154"
WshShell.sendKeys "{ENTER}"
next