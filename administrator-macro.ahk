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
	Sleep, 3000
	Send, {Enter}
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
	Sleep, 3000
	Send, {Enter}
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
	log("9", "Updated Windows Defender and ran a full scan")
	
	adminStep = 10
	updateLine(2, adminStep)
}

;;
; Step 10 - Change Windows Update Settings
; --------------------------------------
;

if (adminStep = 10) {
	Run, control /name Microsoft.WindowsUpdate
	Sleep, 1000
	
	MouseMoveLT(100, 150)
	Click
	Sleep, 500
	
	Loop, 3 {
		Send, {Tab}
	}
	
	Loop, 5 {
		Send, {Down}
	}
	
	Send, {Up}
	
	Loop, 3 {
		Send, {Tab}
	}
	
	Send, {Enter}
	log("10", "Updated Windows Update settings")
	
	Send, !{F4}
	Sleep, 1000
	
	adminStep = 11
	updateLine(2, adminStep)
}

;;
; Step 11 - Perform a Windows Update
; --------------------------------------
;

if (adminStep = 11) {	
; ErrorLevel will contain the return codes from WUInstall.exe mentioned here: help.wuinstall.com/en/ReturnCodes.html
	Loop {
		RunWait, %BatchDir%\WUInstall.exe /install, , UseErrorLevel
		Sleep, 1000
	
		if (ErrorLevel = 0) {           ; Successful, no reboot required
			log("11", "Successfully installed Windows Updates, no reboot was required")
		} else if (ErrorLevel = 1) {    ; At least one error occurred, no reboot required
			log("11", "Installed Windows Updates with at least one error, no reboot was required")
			SoundBeep, 750, 1500
			MsgBox, Your computer encountered at least one error while installing Windows Updates. The program will attempt to install them again.
		} else if (ErrorLevel = 2) {    ; No more updates available
			log("11", "Finished installing Windows Updates")
			break
		} else if (ErrorLevel = 3) {    ; No updates available that match your search
			log("11", "Finished installing Windows Updates")
			break
		} else if (ErrorLevel = 4) {    ; Invalid criteria specified
			log("11", "Internal program error - WUInstall exited with error code 4: Invalid criteria specified")
			SoundBeep, 750, 1500
			MsgBox, An internal program error has occurred. Please check the logs located at: %LogLoc%. This program has been terminated.
			Pause
		} else if (ErrorLevel = 5) {    ; Reboot/shutdown initialized successful
			log("11", "Rebooting after Windows Updates")
			SoundBeep, 750, 1500
			MsgBox, Your computer is now rebooting, please log in again as qauser.
			Pause
		} else if (ErrorLevel = 6) {    ; Reboot/shutdown failed
			log("11", "Failed to reboot after Windows Updates")
			SoundBeep, 750, 1500
			MsgBox, Your computer was unable to automatically reboot after the Windows Update has completed. Please reboot manually and log in again as qauser.
			Pause
		} else if (ErrorLevel = 7) {    ; Syntax error, wrong command
			log("11", "Internal program error - WUInstall exited with error code 7: Syntax error, wrong command")
			SoundBeep, 750, 1500
			MsgBox, An internal program error has occurred. Please check the logs located at: %LogLoc%. This program has been terminated.
			Pause
		} else if (ErrorLevel = 8) {    ; Invalid version, expiration date reached
			log("11", "Internal program error - WUInstall exited with error code 8: Invalid version, expiration date reached")
			SoundBeep, 750, 1500
			MsgBox, An internal program error has occurred. Please check the logs located at: %LogLoc%. This program has been terminated.
			Pause
		} else if (ErrorLevel = 10) {   ; Successful, reboot required
			log("11", "Successfully installed Windows Updates, reboot was required")
			SoundBeep, 750, 1500
			MsgBox, Your computer is now rebooting, please log in again as qauser.
			Shutdown, 6
			Pause
		} else if (ErrorLevel = 11) {   ; At least one error occurred, reboot required
			log("11", "Installed Windows Updates with at least one error, reboot was required")
			SoundBeep, 750, 1500
			MsgBox, Your computer encountered at least one error while installing Windows Updates. The program will attempt to install them again.`n`nYour computer is now rebooting, please log in again as qauser.
			Shutdown, 6
			Pause
		} else if (ErrorLevel = 12) {   ; Timeout reached
			log("11", "Internal program error - WUInstall exited with error code 12: Timeout reached")
			SoundBeep, 750, 1500
			MsgBox, An internal program error has occurred. Please check the logs located at: %LogLoc%. This program has been terminated.
			Pause
		}
	}
	
	adminStep = 12
	updateLine(2, adminStep)
}

;;
; Step 12 - Install OpenOffice
; --------------------------------------
;

if (adminStep = 12) {
	RunWait, %BatchDir%\download-openoffice.bat
	log("12", "Downloaded OpenOffice")
	Sleep, 1000
	
	Run, %DownloadDir%\openoffice.exe
	Sleep, 5000
	
	Send, {Enter}
	Sleep, 1000
	
	Send, %DownloadDir%\openoffice
	Send, {Enter}
	Sleep, 10000
	log("12", "Unpacked the OpenOffice installer")
	
	RunWait, %BatchDir%\install-openoffice.bat
	log("12", "Installed OpenOffice")
	Sleep, 1000
	
	adminStep = 13
	updateLine(2, adminStep)
}