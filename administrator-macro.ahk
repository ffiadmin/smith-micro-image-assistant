; Hide the GUI and begin the macro script
Gui, Hide

;;
; Step 1 - Activate Windows
; --------------------------------------
;

if (adminStep = 1) {
	Run, cmd.exe, , , PID
	Sleep, 1000

	Send, slmgr /upk{Enter}
	Sleep, 5000
	Send, {Enter}
	log("1", "Uninstalled the old product key")

	Send, slmgr /ipk %OSKey%{Enter}
	Sleep, 5000
	Send, {Enter}
	log("1", "Activated Windows with the product key " . OSKey)
	
	Process, Close, %PID%
	Sleep, 1000

	adminStep = 2
	updateLine(2, adminStep)
}

;;
; Step 2 - Add Desktop Icons
; --------------------------------------
;

if (adminStep = 2) {
	Run, cmd.exe, , , PID
	Sleep, 1000
	
	Send, % "desk.cpl, 0"
	Send, {Enter}
	Sleep, 1000
	log("2", "Opened Desktop Icon Settings dialog")
	
	Send, m
	Send, u
	Send, n
	Send, l
	Send, {Enter}
	Sleep, 1000
	log("2", "Added the Computer, User's Files, and Network icons to the desktop. Themes cannot change the desktop icons.")
	
	Process, Close, %PID%
	Sleep, 1000
	
	adminStep = 3
	updateLine(2, adminStep)
}

;;
; Step 3 - Adjust the Time Zone
; --------------------------------------
;

if (adminStep = 3) {
	Run, cmd.exe, , , PID
	Sleep, 1000
	
	Send, tzutil /s "%timeZone%"
	Send, {Enter}
	Sleep, 1000
	log("3", "The time zone was set to " . timeZone)
	
	Process, Close, %PID%
	Sleep, 1000
	
	adminStep = 4
	updateLine(2, adminStep)
}

;;
; Step 4 - Adjust the Color Scheme
; --------------------------------------
;

if (adminStep = 4) {
	Run, %ThemeDir%\Temporary.deskthemepack
	Sleep, 1000
	
	Send, !{F4}
	Sleep, 1000
	log("4", "Applied a custom theme and color scheme")
	
	adminStep = 5
	updateLine(2, adminStep)
}

;;
; Step 5 - Disable Action Center Messages
; --------------------------------------
;

if (adminStep = 5) {
	Run, control /name Microsoft.ActionCenter, , , PID
	Sleep, 1000
	
	MouseMoveLT(120, 120)
	Click
	Sleep, 500
	
	MouseMoveCT(90, 275)
	Click
	log("5", "Disabled Windows SmartScreen alerts from the Action Center")
	MouseMoveCT(-200, 200)
	Click
	log("5", "Disabled Windows Update alerts from the Action Center")
	
	Loop, 5 {
		Send, +{Tab}
	}
	
	Send, {Enter}
	Process, Close, %PID%
	Sleep, 1000
	
	adminStep = 6
	updateLine(2, adminStep)
}

;;
; Step 6 - Create a Shutdown icon
; --------------------------------------
;

if (adminStep = 6) {
	Run, cmd.exe, , , PID
	Sleep, 1000
	
	Send, %BatchDir%\shortcut.exe /F:"%AppData%\Microsoft\Windows\Start Menu\Programs\Shutdown.lnk" /A:c /T:"shutdown" /P:"/s /t 0" /I:"%SystemRoot%\system32\SHELL32.dll,27"
	Send {Enter}
	log("6", "Added a Shutdown icon to the Start Screen")
	
	Process, Close, %PID%
	Sleep, 1000
	
	adminStep = 7
	updateLine(2, adminStep)
}

;;
; Step 7 - Create a Restart icon
; --------------------------------------
;

if (adminStep = 7) {
	Run, cmd.exe, , , PID
	Sleep, 1000
	
	Send, %BatchDir%\shortcut.exe /F:"%AppData%\Microsoft\Windows\Start Menu\Programs\Restart.lnk" /A:c /T:"shutdown" /P:"/r /t 0" /I:"%SystemRoot%\system32\SHELL32.dll,238"
	Send {Enter}
	log("7", "Added a Restart icon to the Start Screen")
	
	Process, Close, %PID%
	Sleep, 1000
	
	adminStep = 8
	updateLine(2, adminStep)
}

;;
; Step 8 - Enable hibernate
; --------------------------------------
;

if (adminStep = 8) {
	Run, control /name Microsoft.PowerOptions, , , PID
	Sleep, 1000
	
	MouseMoveLT(150, 150)
	Click
	Sleep, 500
	
	MouseMoveCT(-200, 160)
	Click
	Sleep, 500
	
	Loop, 12 {
		Send, {Tab}
	}
	
	Send, {Space}
	
	Loop, 4 {
		Send, {Tab}
	}
	
	Send, {Enter}
	log("8", "Enabled Hibernation")
	
	Process, Close, %PID%
	Sleep, 1000
	
	adminStep = 9
	updateLine(2, adminStep)
}

;;
; Step 9 - Update Windows Defender and
;          run a Full Scan
; --------------------------------------
;

if (adminStep = 9) {
	RunWait, %BatchDir%\windows-defender-update-and-scan.bat
	
	adminStep = 10
	updateLine(2, adminStep)
}