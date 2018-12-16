#$language = "VBScript"
#$interface = "1.0"

crt.Screen.Synchronous = True

' This automatically generated script may need to be
' edited in order to work correctly.

Sub Main

'发送命令 
'crt.Screen.Send "whyy@dsl-vty" & chr(13) 
	str1 = "ifconfig eth0 172.18.13.154"
	for i = 1 to 5
	crt.Screen.Send str1 & vbcr
	crt.Screen.Send "{ENTER}"
	crt.Sleep 1000
	next

'等待字符串出现 
'crt.Screen.WaitForString "Password:" 

'等待字符串出现，等待1秒钟 
'crt.Screen.WaitForString ("Password:",1) 

'开启同步 
'crt.Screen.Synchronous = True 

'判断指针1秒内不移动，用于确定安全连接可以进行后续代码输入操作 
'Do 
'bCursorMoved = crt.Screen.WaitForCursor(1) 
'Loop until bCursorMoved = False 

'判定是否已经连接到设备 
'if crt.Session.Connected = true then 

'断开连接 
'crt.session.disConnect 

'激活窗口 用于多tab页面 
'crt.Activate 

'连接到指定设备 
'crt.session.Connect("/telnet " & b(n)) 

'延时1秒 
'crt.Sleep 1000

End Sub
