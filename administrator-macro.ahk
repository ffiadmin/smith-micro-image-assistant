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
	Send, {Enter}
	Sleep, 3000
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
	Send, {Enter}
	Sleep, 3000
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

;;
; Step 13 - Start OpenOffice
; --------------------------------------
;

if (adminStep = 13) {
	Run, cmd.exe, , , PID
	Sleep, 1000
	
	Send, C:{Enter}
	Send, cd %PROGRAMFILES%{Enter}
	
	if (OSType = 64-bit) {
		Send, cd "..\Program Files (x86)"{Enter}
	}
	
	Send, cd OpenOffice{Tab}{Enter}
	Send, cd program{Enter}
	Send, swriter{Enter}
	Sleep, 10000
	
	Send, {Enter}
	Sleep, 1000
	Send, {Enter}
	Sleep, 15000
	
	Send, !{F4}
	Process, Close, %PID%
	Sleep, 1000
	log("13", "Opened and registered OpenOffice Writer")
	
	adminStep = 14
	updateLine(2, adminStep)
}

;;
; Step 14 - Pin Programs to Start Screen
; --------------------------------------
;

if (adminStep = 14) {
	Run, cmd.exe, , , PID
	Sleep, 1000
	
	Send, %BatchDir%\shortcut /F:"%AppData%\Microsoft\Windows\Start Menu\Programs\regedit.lnk" /A:c /T:"%WINDIR%\regedit.exe"
	Send, {Enter}
	Sleep, 3000
	log("14", "Added the Registry Editor to the Start Screen")
	
	Process, Close, %PID%
	Sleep, 1000

	Run, %BatchDir%\pin.vbs
	Sleep, 3000
	log("14", "Added Paint and Notepad to the Start Screen")
	
	RunWait, %BatchDir%\correct-start-menu-shortcuts.bat
	Sleep, 3000
	log("14", "Renamed newly added Start Screen items to friendly names")
	
	adminStep = 15
	updateLine(2, adminStep)
}

;;
; Step 15 - Setup MS Paint
; --------------------------------------
;

if (adminStep = 15) {
	Run, mspaint.exe
	Sleep, 3000
	
	MouseMoveLT(30, 40)
	Click
	Sleep, 500
	
	MouseMoveLT(50, 160)
	Sleep, 1000
	
	MouseMoveLT(50, 100)
	Click Right
	Sleep, 500
	
	MouseMoveLT(30, 10)
	Click
	Sleep, 500
	log("15", "Added Save as JPEG to the Quick Access toolbar in Paint")
	
	MouseMoveRT(70, 10)
	Click
	Sleep, 500
	log("15", "Maximized Paint")
	
	Send, !{F4}
	Sleep, 1000
	
	adminStep = 16
	updateLine(2, adminStep)
}

;;
; Step 16 - Setup Notepad
; --------------------------------------
;

if (adminStep = 16) {
	Run, notepad.exe
	Sleep, 1000
	
	Send, {Alt}
	Send, o
	Send, w
	Sleep, 1000
	log("16", "Enabled word wrap in Notepad")
	
	MouseMoveRT(70, 10)
	Click
	Sleep, 500
	log("16", "Maximized Notepad")
	
	Send, !{F4}
	Sleep, 1000
	
	adminStep = 17
	updateLine(2, adminStep)
}

;;
; Step 17 - Setup Internet Explorer
; --------------------------------------
;

if (adminStep = 17) {
	Run, %BatchDir%\internet-explorer-home-page.bat
	Sleep, 5000
	
	Send, {Alt}
	Sleep, 500
	Send, t
	Sleep, 500
	Send, o
	Sleep, 1000
	
	Send, {Tab}
	Send, {Enter}
	
	Loop, 12 {
		Send, {Tab}
	}
	
	Send, {Enter}
	Sleep, 1000
	
	Send, !{F4}
	Sleep, 1000
	log("17", "Set Internet Explorer homepage to google.com")
	
	Run, %BatchDir%\internet-explorer-search-engine.bat
	Sleep, 5000
	
	MouseMoveCT(100, 500)
	Click
	Sleep, 3000
	
	Send, {Enter}
	
	Send, {Alt}
	Sleep, 500
	Send, t
	Sleep, 500
	Send, a
	Sleep, 1000
	
	Send, {Down}
	Sleep, 500
	Send, {Right}
	Sleep, 500
	Send, {Down}
	Sleep, 500
	
	Send, !u
	Sleep, 500
	Send, {Up}
	Sleep, 500
	Send, {Up}
	Sleep, 500
	Send, !m
	Sleep, 500
	
	Send, !l
	Sleep, 500
	log("17", "Set Internet Explorer default search engine to Google and removed Bing")
	
	Send, !{F4}
	Sleep, 1000
	
	adminStep = 18
	updateLine(2, adminStep)
}

;;
; Step 18 - Configure Folder Options
; --------------------------------------
;

if (adminStep = 18) {
	; Guess you can't modify the registry directly :-(
	
	;RegWrite, Reg_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1          ; Show hidden files, folders, and drives
	;RegWrite, Reg_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 0     ; Show file extensions
	;RegWrite, Reg_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, SharingWizardOn, 0 ; Disable Sharing Wizard
	;RegWrite, Reg_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, ShowSuperHidden, 1 ; Show protected OS files
	
	Run, cmd.exe
	Sleep, 1000
	
	Send, powershell{Enter}
	Sleep, 3000
	
	Send, Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' Hidden 1{Enter}
	log("18", "Showing hidden files, folders, and drives")
	Sleep, 3000
	Send, Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' HideFileExt 0{Enter}
	log("18", "Showing all file extensions")
	Sleep, 3000
	Send, Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' SharingWizardOn 0{Enter}
	log("18", "Disabled Sharing Wizard")
	Sleep, 3000
	Send, Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' ShowSuperHidden 1{Enter}
	log("18", "Showing protected operating system files")
	Sleep, 3000
	Send, exit{Enter}
	Sleep, 1000
	Send, exit{Enter}
	Sleep, 1000

	adminStep = 19
	updateLine(2, adminStep)
}

;;
; Step 19 - Download and Install Java
; --------------------------------------
;

if (adminStep = 19) {
	Run, %BatchDir%\internet-explorer-java-download.bat
	Sleep, 5000
	
	MouseMoveCT(100, 285)
	Click Right
	Sleep, 500
	
	Loop, 4 {
		Send, {Down}
	}
	
	Send, {Enter}
	Sleep, 5000
	
	Send, %DownloadDir%\java-32.exe{Enter}
	Sleep, 300000 ; Wait 5 mins for download to complete
	Send, !{F4}
	log("19", "Java download complete")
	
	RunWait, %DownloadDir%\java-32.exe /s
	log("19", "Java install complete")
	
	Run, %BatchDir%\internet-explorer.bat
	Sleep, 5000
	
	Send, {Alt}
	Sleep, 500
	Send, t
	Sleep, 500
	Send, a
	Sleep, 1000
	
	Send, {Right}
	Sleep, 500
	Send, {Up}
	Sleep, 500
	
	Send, !e
	Sleep, 500
	Send, !l
	Sleep, 500
	Send, !{F4}
	Sleep, 1000	
	log("19", "Enabled the Java plugin for Internet Explorer")
	
	adminStep = 20
	updateLine(2, adminStep)
}