; Hide the GUI and begin the macro script
Gui, Hide

; Is this the qauser account?
if (A_Username != "qauser") {
	SoundBeep, 750, 1500
	MsgBox, 16, Incorrect User Account, You are not logged in as qauser. Please log in as qauser.
	Shutdown, 4
	Pause
}

;;
; Step 1 - Activate Windows
; --------------------------------------
;

if (adminStep = 1) {
	if (OSKey != "") {
		tip(adminStep, "Installing Windows license key and activating the operating system", AdminStepTotal)
		
		Run, cmd.exe, , , PID
		Sleep, 1000

		Send, slmgr /upk{Enter}
		Sleep, 5000
		Send, {Enter}
		log(adminStep, "Uninstalled the old product key")

		Send, slmgr /ipk %OSKey%{Enter}
		Sleep, 5000
		Send, {Enter}
		log(adminStep, "Activated Windows with the product key " . OSKey)
		
		Process, Close, %PID%
		Sleep, 1000
	} else {
		tip(adminStep, "Skipped installing Windows license key", AdminStepTotal)
		log(adminStep, "Product key was not installed")
	}
		
	adminStep = 2
	updateLine(2, adminStep)
}

;;
; Step 2 - Add Desktop Icons
; --------------------------------------
;

if (adminStep = 2) {
	tip(adminStep, "Adding commonly used icons to the desktop", AdminStepTotal)

	Run, cmd.exe, , , PID
	Sleep, 1000
	
	Send, % "desk.cpl, 0"
	Send, {Enter}
	Sleep, 1000
	log(adminStep, "Opened Desktop Icon Settings dialog")
	
	Send, m
	Send, u
	Send, n
	Send, l
	Send, {Enter}
	Sleep, 1000
	log(adminStep, "Added the Computer, User's Files, and Network icons to the desktop. Themes cannot change the desktop icons.")
	
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
	tip(adminStep, "Adjusting the system's time zone", AdminStepTotal)

	Run, cmd.exe, , , PID
	Sleep, 1000
	
	Send, tzutil /s "%timeZone%"
	Send, {Enter}
	Sleep, 1000
	log(adminStep, "The time zone was set to " . timeZone)
	
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
	tip(adminStep, "Adjusting the system's color scheme and desktop background", AdminStepTotal)

	Run, %ThemeDir%\Temporary.deskthemepack
	Sleep, 1000
	
	Send, !{F4}
	Sleep, 1000
	log(adminStep, "Applied a custom theme and color scheme")
	
	adminStep = 5
	updateLine(2, adminStep)
}

;;
; Step 5 - Disable Action Center Messages
; --------------------------------------
;

if (adminStep = 5) {
	tip(adminStep, "Disabling Action Center messages", AdminStepTotal)

	Run, control /name Microsoft.ActionCenter, , , PID
	Sleep, 1000
	
	MouseMoveLT(120, 120)
	Click
	Sleep, 500
	
	MouseMoveCT(90, 275)
	Click
	log(adminStep, "Disabled Windows SmartScreen alerts from the Action Center")
	MouseMoveCT(-200, 200)
	Click
	log(adminStep, "Disabled Windows Update alerts from the Action Center")
	
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
	tip(adminStep, "Creating a one-click shutdown icon", AdminStepTotal)

	Run, cmd.exe, , , PID
	Sleep, 1000
	
	Send, %BatchDir%\shortcut.exe /F:"%AppData%\Microsoft\Windows\Start Menu\Programs\Shutdown.lnk" /A:c /T:"shutdown" /P:"/s /t 0" /I:"%SystemRoot%\system32\SHELL32.dll,27"
	Send, {Enter}
	Sleep, 3000
	log(adminStep, "Added a Shutdown icon to the Start Screen")
	
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
	tip(adminStep, "Creating a one-click restart icon", AdminStepTotal)

	Run, cmd.exe, , , PID
	Sleep, 1000
	
	Send, %BatchDir%\shortcut.exe /F:"%AppData%\Microsoft\Windows\Start Menu\Programs\Restart.lnk" /A:c /T:"shutdown" /P:"/r /t 0" /I:"%SystemRoot%\system32\SHELL32.dll,238"
	Send, {Enter}
	Sleep, 3000
	log(adminStep, "Added a Restart icon to the Start Screen")
	
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
	tip(adminStep, "Enabling hibernate", AdminStepTotal)

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
	log(adminStep, "Enabled Hibernation")
	
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
	tip(adminStep, "Updating Windows Defender and running a full system scan", AdminStepTotal)

	RunWait, %BatchDir%\windows-defender-update-and-scan.bat
	log(adminStep, "Updated Windows Defender and ran a full scan")
	
	adminStep = 10
	updateLine(2, adminStep)
}

;;
; Step 10 - Change Windows Update Settings
; --------------------------------------
;

if (adminStep = 10) {
	tip(adminStep, "Modifying Windows Update settings", AdminStepTotal)

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
	log(adminStep, "Updated Windows Update settings")
	
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
	tip(adminStep, "Running Windows Update", AdminStepTotal)

; ErrorLevel will contain the return codes from WUInstall.exe mentioned here: help.wuinstall.com/en/ReturnCodes.html
	Loop {
		RunWait, %BatchDir%\WUInstall.exe /install, , UseErrorLevel
		Sleep, 1000
	
		if (ErrorLevel = 0) {           ; Successful, no reboot required
			log(adminStep, "Successfully installed Windows Updates, no reboot was required")
		} else if (ErrorLevel = 1) {    ; At least one error occurred, no reboot required
			log(adminStep, "Installed Windows Updates with at least one error, no reboot was required")
			SoundBeep, 750, 1500
			MsgBox, 64, Windows Update Notification, Your computer encountered at least one error while installing Windows Updates. The program will attempt to install them again.
		} else if (ErrorLevel = 2) {    ; No more updates available
			log(adminStep, "Finished installing Windows Updates")
			break
		} else if (ErrorLevel = 3) {    ; No updates available that match your search
			log(adminStep, "Finished installing Windows Updates")
			break
		} else if (ErrorLevel = 4) {    ; Invalid criteria specified
			log(adminStep, "Internal program error - WUInstall exited with error code 4: Invalid criteria specified")
			SoundBeep, 750, 1500
			MsgBox, 16, Windows Update Failed, An internal program error has occurred. Please check the logs located at: %LogLoc%. This program has been terminated.
			Pause
		} else if (ErrorLevel = 5) {    ; Reboot/shutdown initialized successful
			log(adminStep, "Rebooting after Windows Updates")
			SoundBeep, 750, 1500
			MsgBox, 0, Reboot Notification, Your computer is now rebooting, please log in again as qauser.
			Pause
		} else if (ErrorLevel = 6) {    ; Reboot/shutdown failed
			log(adminStep, "WUInstall.exe failed to reboot after Windows Updates had completed. Program is forcing a reboot.")
			SoundBeep, 750, 1500
			MsgBox, 0, Reboot Notification, Your computer is now rebooting, please log in again as qauser.
			Shutdown, 6
			Pause
		} else if (ErrorLevel = 7) {    ; Syntax error, wrong command
			log(adminStep, "Internal program error - WUInstall exited with error code 7: Syntax error, wrong command")
			SoundBeep, 750, 1500
			MsgBox, 16, Windows Update Failed, An internal program error has occurred. Please check the logs located at: %LogLoc%. This program has been terminated.
			Pause
		} else if (ErrorLevel = 8) {    ; Invalid version, expiration date reached
			log(adminStep, "Internal program error - WUInstall exited with error code 8: Invalid version, expiration date reached")
			SoundBeep, 750, 1500
			MsgBox, 16, Windows Update Failed, An internal program error has occurred. Please check the logs located at: %LogLoc%. This program has been terminated.
			Pause
		} else if (ErrorLevel = 10) {   ; Successful, reboot required
			log(adminStep, "Successfully installed Windows Updates, reboot was required")
			SoundBeep, 750, 1500
			MsgBox, 0, Reboot Notification, Your computer is now rebooting, please log in again as qauser.
			Shutdown, 6
			Pause
		} else if (ErrorLevel = 11) {   ; At least one error occurred, reboot required
			log(adminStep, "Installed Windows Updates with at least one error, reboot was required")
			SoundBeep, 750, 1500
			MsgBox, 64, Windows Update Notification, Your computer encountered at least one error while installing Windows Updates. The program will attempt to install them again.`n`nYour computer is now rebooting, please log in again as qauser.
			Shutdown, 6
			Pause
		} else if (ErrorLevel = 12) {   ; Timeout reached
			log(adminStep, "Internal program error - WUInstall exited with error code 12: Timeout reached")
			SoundBeep, 750, 1500
			MsgBox, 16, Windows Update Failed, An internal program error has occurred. Please check the logs located at: %LogLoc%. This program has been terminated.
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
	tip(adminStep, "Downloading and installing Apache OpenOffice 4.0.0", AdminStepTotal)

	RunWait, %BatchDir%\download-openoffice.bat
	log(adminStep, "Downloaded OpenOffice 4.0.0")
	Sleep, 1000
	
	Run, %DownloadDir%\openoffice.exe
	Sleep, 5000
	
	Send, {Enter}
	Sleep, 1000
	
	Send, %DownloadDir%\openoffice
	Send, {Enter}
	Sleep, 30000
	log(adminStep, "Unpacked the OpenOffice installer")
	
	Send, !{F4}
	Sleep, 1000
	Send, {Enter}
	Sleep, 1000
	
	RunWait, %BatchDir%\install-openoffice.bat
	log(adminStep, "Installed OpenOffice")
	Sleep, 1000
	
	adminStep = 13
	updateLine(2, adminStep)
}

;;
; Step 13 - Start OpenOffice
; --------------------------------------
;

if (adminStep = 13) {
	tip(adminStep, "Opening and registering OpenOffice", AdminStepTotal)

	Run, cmd.exe, , , PID
	Sleep, 1000
	
	Send, %SYSTEMDRIVE%{Enter}
	Send, cd %PROGRAMFILES%{Enter}
	Sleep, 500
	
	if (OSType = "64-bit") {
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
	log(adminStep, "Opened and registered OpenOffice Writer")
	
	adminStep = 14
	updateLine(2, adminStep)
}

;;
; Step 14 - Pin Programs to Start Screen
; --------------------------------------
;

if (adminStep = 14) {
	tip(adminStep, "Pinning commonly used programs to the Start Screen", AdminStepTotal)

	Run, cmd.exe, , , PID
	Sleep, 1000
	
	Send, %BatchDir%\shortcut /F:"%AppData%\Microsoft\Windows\Start Menu\Programs\regedit.lnk" /A:c /T:"%WINDIR%\regedit.exe"
	Send, {Enter}
	Sleep, 3000
	log(adminStep, "Added the Registry Editor to the Start Screen")
	
	Process, Close, %PID%
	Sleep, 1000

	Run, %BatchDir%\pin.vbs
	Sleep, 3000
	log(adminStep, "Added Paint and Notepad to the Start Screen")
	
	RunWait, %BatchDir%\correct-start-menu-shortcuts.bat
	Sleep, 3000
	log(adminStep, "Renamed newly added Start Screen items to friendly names")
	
	adminStep = 15
	updateLine(2, adminStep)
}

;;
; Step 15 - Set up MS Paint
; --------------------------------------
;

if (adminStep = 15) {
	tip(adminStep, "Configuring Paint", AdminStepTotal)

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
	log(adminStep, "Added Save as JPEG to the Quick Access toolbar in Paint")
	
	MouseMoveRT(70, 10)
	Click
	Sleep, 500
	log(adminStep, "Maximized Paint")
	
	Send, !{F4}
	Sleep, 1000
	
	adminStep = 16
	updateLine(2, adminStep)
}

;;
; Step 16 - Set up Notepad
; --------------------------------------
;

if (adminStep = 16) {
	tip(adminStep, "Configuring Notepad", AdminStepTotal)

	Run, notepad.exe
	Sleep, 1000
	
	Send, {Alt}
	Send, o
	Send, w
	Sleep, 1000
	log(adminStep, "Enabled word wrap in Notepad")
	
	MouseMoveRT(70, 10)
	Click
	Sleep, 500
	log(adminStep, "Maximized Notepad")
	
	Send, !{F4}
	Sleep, 1000
	
	adminStep = 17
	updateLine(2, adminStep)
}

;;
; Step 17 - Set up Internet Explorer
; --------------------------------------
;

if (adminStep = 17) {
	tip(adminStep, "Configuring Internet Explorer", AdminStepTotal)

	Run, %BatchDir%\internet-explorer-home-page.bat
	Sleep, 10000
	
	Send, {Space}
	Sleep, 500
	Send, {Tab}{Tab}
	Sleep, 500
	Send, {Enter}
	Sleep, 500

	WinActivate, Windows Internet Explorer
	Sleep, 500
	
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
	log(adminStep, "Set Internet Explorer homepage to google.com")
	
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
	log(adminStep, "Set Internet Explorer default search engine to Google and removed Bing")
	
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
	
	tip(adminStep, "Configuring folder options to show file extensions and hidden files", AdminStepTotal)
	
	Run, cmd.exe
	Sleep, 1000
	
	Send, powershell{Enter}
	Sleep, 3000
	
	Send, Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' Hidden 1{Enter}
	log(adminStep, "Showing hidden files, folders, and drives")
	Sleep, 3000
	Send, Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' HideFileExt 0{Enter}
	log(adminStep, "Showing all file extensions")
	Sleep, 3000
	Send, Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' SharingWizardOn 0{Enter}
	log(adminStep, "Disabled Sharing Wizard")
	Sleep, 3000
	Send, Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' ShowSuperHidden 1{Enter}
	log(adminStep, "Showing protected operating system files")
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
	tip(adminStep, "Downloading and installing the latest version of Java", AdminStepTotal)

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
	log(adminStep, "Java download complete")
	
	RunWait, %DownloadDir%\java-32.exe /s
	log(adminStep, "Java install complete")
	
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
	log(adminStep, "Enabled the Java plugin for Internet Explorer")
	
	adminStep = 20
	updateLine(2, adminStep)
}

;;
; Step 20 - Download and Install Reader
; --------------------------------------
;

if (adminStep = 20) {
	tip(adminStep, "Downloading and installing the latest version of Adobe Reader", AdminStepTotal)

	Run, cmd.exe, , , PID
	Sleep, 1000
	
	Send, %SYSTEMDRIVE%{Enter}
	Sleep, 500
	
	Send, netsh advfirewall firewall add rule name = "WinFTPIn" dir=in action=allow profile=any description="Windows FTP Client Allow In Traffic" program=%SYSTEMDRIVE%\Windows\System32\ftp.exe{Enter}
	Sleep, 5000
	Send, netsh advfirewall firewall add rule name = "WinFTPOut" dir=out action=allow profile=any description="Windows FTP Client Allow Out Traffic" program=%SYSTEMDRIVE%\Windows\System32\ftp.exe{Enter}
	Sleep, 5000
	
	if (OSType = "64-bit") {
		Send, netsh advfirewall firewall add rule name = "WinFTPx64In" dir=in action=allow profile=any description="Windows FTP x64 Client Allow In Traffic" program=%SYSTEMDRIVE%\Windows\SysWOW64\ftp.exe{Enter}
		Sleep, 5000
		Send, netsh advfirewall firewall add rule name = "WinFTPx64Out" dir=out action=allow profile=any description="Windows FTP x64 Client Allow Out Traffic" program=%SYSTEMDRIVE%\Windows\SysWOW64\ftp.exe{Enter}
		Sleep, 5000
	}
	
	log(adminStep, "Enabled FTP downloads through the Windows firewall")
	
	Process, Close, %PID%
	Sleep, 1000
	
	RunWait, %BatchDir%\download-install-reader.bat
	
	Run, cmd.exe, , , PID
	Sleep, 1000
	
	Send, %SYSTEMDRIVE%{Enter}
	Sleep, 500
	
	Send, netsh advfirewall firewall delete rule name = "WinFTPIn"{Enter}
	Sleep, 5000
	Send, netsh advfirewall firewall delete rule name = "WinFTPOut" {Enter}
	Sleep, 5000
	
	if (OSType = "64-bit") {
		Send, netsh advfirewall firewall delete rule name = "WinFTPx64In"{Enter}
		Sleep, 5000
		Send, netsh advfirewall firewall delete rule name = "WinFTPx64Out"{Enter}
		Sleep, 5000
	}
	
	log(adminStep, "Disabled FTP downloads through the Windows firewall")
	
	Process, Close, %PID%
	Sleep, 1000
	
	; Sometimes the download will not work (in a timely manner), so provide a timeout to try again
	;Loop {
	;	Process, WaitClose, %BatchDir%\download-install-reader.bat, 420 ; Wait for 7 minutes before timing out
	;	
	;	if (ErrorLevel = 0) { ; Horray!
	;		break
	;	} else {              ; Boo
	;		Process, Close, %ErrorLevel%
	;	}
	;}
	
	Sleep, 1000
	log(adminStep, "Downloaded and installed Acrobat Reader")
	
	Run, cmd.exe, , , PID
	Sleep, 1000
	
	Send, %SYSTEMDRIVE%{Enter}
	Send, cd %PROGRAMFILES%{Enter}
	Sleep, 500
	
	if (OSType = "64-bit") {
		Send, cd "..\Program Files (x86)"{Enter}
		Sleep, 500
	}
	
	Send, cd Adobe{Enter}
	Sleep, 500
	Send, cd Reader{Tab}
	Sleep, 500
	Send, {Enter}
	Sleep, 500
	Send, cd Reader{Enter}
	Sleep, 500
	Send, AcroRd32.exe{Enter}
	Sleep, 10000
	
	Send, {Tab}
	Sleep, 500
	Send, {Enter}
	Sleep, 5000
	
	MouseMoveRT(200, 70)
	Click
	Sleep, 500
	
	Send, !{F4}
	log(adminStep, "Accepted Acrobat Reader EULA")
	
	Process, Close, %PID%
	Sleep, 1000
	
	adminStep = 21
	updateLine(2, adminStep)
}

;;
; Step 21 - Download and Install 7-Zip
; --------------------------------------
;

if (adminStep = 21) {
	tip(adminStep, "Downloading and installing 7-Zip 9.20", AdminStepTotal)

	RunWait, %BatchDir%\wget.exe http://downloads.sourceforge.net/sevenzip/7z920.exe -O %DownloadDir%\7zip.exe
	Sleep, 2000
	log(adminStep, "Downloaded 7-zip 9.20")
	
	RunWait, %DownloadDir%\7zip.exe /S
	Sleep, 2000
	log(adminStep, "Installed 7-zip")
	
	adminStep = 22
	updateLine(2, adminStep)
}

;;
; Step 22 - Show Notification Area Icons
; --------------------------------------
;

if (adminStep = 22) {
	tip(adminStep, "Showing all Notification Area icons", AdminStepTotal)

	Run, control /name Microsoft.NotificationAreaIcons
	Sleep, 5000
	
	MouseMoveLB(150, 80)
	Click
	Sleep, 1000
	
	MouseMoveRB(200, 30)
	Click
	Sleep, 1000
	log(adminStep, "Displayed all notification area icons")
	
	adminStep = 23
	updateLine(2, adminStep)
}


;;
; Step 23 - Disable System Restore
; --------------------------------------
;

if (adminStep = 23) {
	tip(adminStep, "Disabling System Restore", AdminStepTotal)

	Run, cmd.exe, , , PID
	Sleep, 1000
	
	Send, control /name Microsoft.System{Enter}
	Sleep, 1000
	
	MouseMoveLT(100, 170)
	Click
	Sleep, 1000
	
	Send, {Tab}
	Send, {Tab}
	Sleep, 500
	
	MouseMoveCT(125, 350)
	Click
	Sleep, 1000
	
	Send, {Down}
	Sleep, 500
	
	MouseMoveCT(150, 390)
	Click
	Sleep, 1000
	
	Send, {Tab}
	Send, {Enter}
	Sleep, 10000
	Send, {Enter}
	log(adminStep, "Disabled system restore and deleted old restore points")
	
	Send, {Tab}
	Send, {Enter}
	Sleep, 500
	Send, {Tab}
	Send, {Enter}
	Sleep, 500
	
	Send, !{F4}
	Sleep, 500
	Send, !{F4}
	Sleep, 1000
	
	Process, Close, %PID%
	Sleep, 1000

	adminStep = 24
	updateLine(2, adminStep)
}

;;
; Step 24 - Delete Driver Folders
; --------------------------------------
;

if (adminStep = 24) {
	tip(adminStep, "Deleting HP and Dell driver installer folders", AdminStepTotal)

	RunWait, %BatchDir%\delete-driver-folders.bat
	Sleep, 1000
	log(adminStep, "Deleted HP and Dell drivers folder")

	adminStep = 25
	updateLine(2, adminStep)
}

;;
; Step 25 - Run Disk Clean Up
; --------------------------------------
;

if (adminStep = 25) {
	tip(adminStep, "Running disk clean up", AdminStepTotal)

	Run, cmd.exe, , , PID
	Sleep, 1000
	
; Disk Clean Up does best with a second sweep
	Loop, 2 {
		Send, cleanmgr /d %SYSTEMDRIVE%{Enter}
		Sleep, 40000
		
		Loop, 4 {
			Send, {Down}
		}
		
		Sleep, 500
		Send, {Space}
		Sleep, 500
		
		Loop, 2 {
			Send, {Down}
		}
		
		Sleep, 500
		Send, {Space}
		Sleep, 1000
		
		MouseMoveRB(130, 30)
		Click		
		Sleep, 500
		
		Send, {Enter}
		Sleep, 30000
		log(adminStep, "Performed a Disk Clean Up")
	}

	Process, Close, %PID%
	Sleep, 1000
	
	adminStep = 26
	updateLine(2, adminStep)
}

;;
; Step 26 - Create the Standard User
; --------------------------------------
;

if (adminStep = 26) {
	tip(adminStep, "Creating the standard user account", AdminStepTotal)

	RunWait, net user standard standard /add
	Sleep, 1000
	log(adminStep, "Created the standard user")
	
	log(adminStep, "Finished setting up the Administrator account")
	
	adminStep = 27
	updateLine(2, adminStep)
}

;;
; Step 27 - Prepare application for use
;           in the standard user account
; --------------------------------------
;

if (adminStep = 27) {
	tip(adminStep, "Preparing the program for use in the standard user account", AdminStepTotal)
	
	FileCopy, %BatchDir%\show.scf, %A_SystemDrive%\Users\standard\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\show.scf
	FileCopy, %BatchDir%\start.bat, %A_SystemDrive%\Users\standard\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\start.bat
	Sleep, 1000
	log(adminStep, "Added two files to the standard user's start up folder to show the desktop and start the program on log on")
	
	adminStep = 28
	updateLine(2, adminStep)
	updateLine(1, 4)
	
	SoundBeep, 750, 1500
	MsgBox, 0, Finished Setting up Administrator Account, The program has finished setting up the Administrator account. Your computer will now sign out of the qauser account. Please log in as the standard user.
	Shutdown, 4
	Pause
}