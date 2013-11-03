; Hide the GUI and begin the macro script
Gui, Hide

; Is this the standard user account?
if (A_Username != "standard") {
	SoundBeep, 750, 1500
	MsgBox, 16, Incorrect User Account, You are not logged in as the standard user. Please log in as the standard user.
	Shutdown, 4
	Pause
}

;;
; Step 1 - Add Desktop Icons
; --------------------------------------
;

if (standardStep = 1) {
	tip(standardStep, "Adding commonly used icons to the desktop", StandardStepTotal)

	Run, cmd.exe, , , PID
	Sleep, 1000
	
	Send, % "desk.cpl, 0"
	Send, {Enter}
	Sleep, 1000
	log(standardStep, "Opened Desktop Icon Settings dialog")
	
	Send, m
	Send, u
	Send, n
	Send, l
	Send, {Enter}
	Sleep, 1000
	log(standardStep, "Added the Computer, User's Files, and Network icons to the desktop. Themes cannot change the desktop icons.")
	
	Process, Close, %PID%
	Sleep, 1000
	
	standardStep = 2
	updateLine(3, standardStep)
}

;;
; Step 2 - Adjust the Color Scheme
; --------------------------------------
;

if (standardStep = 2) {
	tip(standardStep, "Adjusting the system's color scheme and desktop background", StandardStepTotal)

	Run, %ThemeDir%\Temporary.deskthemepack
	Sleep, 1000
	
	Send, !{F4}
	Sleep, 1000
	log(standardStep, "Applied a custom theme and color scheme")
	
	standardStep = 3
	updateLine(3, standardStep)
}

;;
; Step 3 - Start OpenOffice
; --------------------------------------
;

if (standardStep = 3) {
	tip(standardStep, "Opening and registering OpenOffice", StandardStepTotal)

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
	log(standardStep, "Opened and registered OpenOffice Writer")
	
	standardStep = 4
	updateLine(3, standardStep)
}

;;
; Step 4 - Start Adobe Reader
; --------------------------------------
;

if (standardStep = 4) {
	tip(standardStep, "Opening and accepting Adobe Reader EULA", StandardStepTotal)

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
	log(standardStep, "Accepted Acrobat Reader EULA")
	
	Process, Close, %PID%
	Sleep, 1000
	
	standardStep = 5
	updateLine(3, standardStep)
}

;;
; Step 5 - Create a Shutdown icon
; --------------------------------------
;

if (standardStep = 5) {
	tip(standardStep, "Creating a one-click shutdown icon", StandardStepTotal)

	Run, cmd.exe, , , PID
	Sleep, 1000
	
	Send, %BatchDir%\shortcut.exe /F:"%AppData%\Microsoft\Windows\Start Menu\Programs\Shutdown.lnk" /A:c /T:"shutdown" /P:"/s /t 0" /I:"%SystemRoot%\system32\SHELL32.dll,27"
	Send, {Enter}
	Sleep, 3000
	log(standardStep, "Added a Shutdown icon to the Start Screen")
	
	Process, Close, %PID%
	Sleep, 1000
	
	standardStep = 6
	updateLine(3, standardStep)
}

;;
; Step 6 - Create a Restart icon
; --------------------------------------
;

if (standardStep = 6) {
	tip(standardStep, "Creating a one-click restart icon", StandardStepTotal)

	Run, cmd.exe, , , PID
	Sleep, 1000
	
	Send, %BatchDir%\shortcut.exe /F:"%AppData%\Microsoft\Windows\Start Menu\Programs\Restart.lnk" /A:c /T:"shutdown" /P:"/r /t 0" /I:"%SystemRoot%\system32\SHELL32.dll,238"
	Send, {Enter}
	Sleep, 3000
	log(standardStep, "Added a Restart icon to the Start Screen")
	
	Process, Close, %PID%
	Sleep, 1000
	
	standardStep = 7
	updateLine(3, standardStep)
}

;;
; Step 7 - Pin Programs to Start Screen
; --------------------------------------
;

if (standardStep = 7) {
	tip(standardStep, "Pinning commonly used programs to the Start Screen", StandardStepTotal)

	Run, cmd.exe, , , PID
	Sleep, 1000
	
	Send, %BatchDir%\shortcut /F:"%AppData%\Microsoft\Windows\Start Menu\Programs\regedit.lnk" /A:c /T:"%WINDIR%\regedit.exe"
	Send, {Enter}
	Sleep, 3000
	log(standardStep, "Added the Registry Editor to the Start Screen")
	
	Process, Close, %PID%
	Sleep, 1000

	Run, %BatchDir%\pin.vbs
	Sleep, 3000
	log(standardStep, "Added Paint and Notepad to the Start Screen")
	
	RunWait, %BatchDir%\correct-start-menu-shortcuts.bat
	Sleep, 3000
	log(standardStep, "Renamed newly added Start Screen items to friendly names")
		
	standardStep = 8
	updateLine(3, standardStep)
}

;;
; Step 8 - Setup MS Paint
; --------------------------------------
;

if (standardStep = 8) {
	tip(standardStep, "Configuring Paint", StandardStepTotal)

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
	log(standardStep, "Added Save as JPEG to the Quick Access toolbar in Paint")
	
	MouseMoveRT(70, 10)
	Click
	Sleep, 500
	log(standardStep, "Maximized Paint")
	
	Send, !{F4}
	Sleep, 1000
	
	standardStep = 9
	updateLine(3, standardStep)
}

;;
; Step 9 - Setup Notepad
; --------------------------------------
;

if (standardStep = 9) {
	tip(standardStep, "Configuring Notepad", StandardStepTotal)

	Run, notepad.exe
	Sleep, 1000
	
	Send, {Alt}
	Send, o
	Send, w
	Sleep, 1000
	log(standardStep, "Enabled word wrap in Notepad")
	
	MouseMoveRT(70, 10)
	Click
	Sleep, 500
	log(standardStep, "Maximized Notepad")
	
	Send, !{F4}
	Sleep, 1000
	
	standardStep = 10
	updateLine(3, standardStep)
}

;;
; Step 10 - Setup Internet Explorer
; --------------------------------------
;

if (standardStep = 10) {
	tip(standardStep, "Configuring Internet Explorer", StandardStepTotal)

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
	log(standardStep, "Set Internet Explorer homepage to google.com")
	
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
	log(standardStep, "Set Internet Explorer default search engine to Google and removed Bing")
	
	Send, !{F4}
	Sleep, 1000
	
	standardStep = 11
	updateLine(3, standardStep)
}

;;
; Step 11 - Show Notification Area Icons
; --------------------------------------
;

if (standardStep = 11) {
	tip(standardStep, "Showing all Notification Area icons", StandardStepTotal)

	Run, control /name Microsoft.NotificationAreaIcons
	Sleep, 5000
	
	MouseMoveLB(150, 80)
	Click
	Sleep, 1000
	
	MouseMoveRB(200, 30)
	Click
	Sleep, 1000
	log(standardStep, "Displayed all notification area icons")
	
	standardStep = 12
	updateLine(3, standardStep)
}

;;
; Step 12 - Disable Action Center Messages
; --------------------------------------
;

if (standardStep = 12) {
	tip(standardStep, "Disabling Action Center messages", StandardStepTotal)

	Run, control /name Microsoft.ActionCenter, , , PID
	Sleep, 1000
	
	MouseMoveLT(120, 120)
	Click
	Sleep, 500
	
	MouseMoveCT(90, 275)
	Click
	log(standardStep, "Disabled Windows SmartScreen alerts from the Action Center")
	MouseMoveCT(-200, 200)
	Click
	log(standardStep, "Disabled Windows Update alerts from the Action Center")
	
	Loop, 5 {
		Send, +{Tab}
	}
	
	Send, {Enter}
	Process, Close, %PID%
	Sleep, 1000
	
	standardStep = 13
	updateLine(3, standardStep)
}

;;
; Step 13 - Run Disk Clean Up
; --------------------------------------
;

if (standardStep = 13) {
	tip(standardStep, "Running disk clean up", StandardStepTotal)

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
		log(standardStep, "Performed a Disk Clean Up")
	}

	Process, Close, %PID%
	Sleep, 1000
	
	standardStep = 14
	updateLine(3, standardStep)
}

;;
; Step 14 - Configure Folder Options
; --------------------------------------
;

if (standardStep = 14) {
	; Guess you can't modify the registry directly :-(
	
	;RegWrite, Reg_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1          ; Show hidden files, folders, and drives
	;RegWrite, Reg_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 0     ; Show file extensions
	;RegWrite, Reg_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, SharingWizardOn, 0 ; Disable Sharing Wizard
	;RegWrite, Reg_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, ShowSuperHidden, 1 ; Show protected OS files
	
	tip(standardStep, "Configuring folder options to show file extensions and hidden files", StandardStepTotal)
	
	Run, cmd.exe
	Sleep, 1000
	
	Send, powershell{Enter}
	Sleep, 3000
	
	Send, Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' Hidden 1{Enter}
	log(standardStep, "Showing hidden files, folders, and drives")
	Sleep, 3000
	Send, Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' HideFileExt 0{Enter}
	log(standardStep, "Showing all file extensions")
	Sleep, 3000
	Send, Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' SharingWizardOn 0{Enter}
	log(standardStep, "Disabled Sharing Wizard")
	Sleep, 3000
	Send, Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' ShowSuperHidden 1{Enter}
	log(standardStep, "Showing protected operating system files")
	Sleep, 3000
	Send, exit{Enter}
	Sleep, 1000
	Send, exit{Enter}
	Sleep, 1000

	standardStep = 15
	updateLine(3, standardStep)
}

;;
; Step 15 - Add 7-Zip to the Start Screen
; --------------------------------------
;

if (standardStep = 15) {
	tip(standardStep, "Adding 7-Zip icon to the Start Screen", StandardStepTotal)
	
	Run, cmd.exe, , , PID
	Sleep, 1000
	
	if (OSType = "64-bit") {
		Send, %BatchDir%\shortcut.exe /F:"%AppData%\Microsoft\Windows\Start Menu\Programs\7-Zip File Manager.lnk" /A:c /T:"%SystemDrive%\Program Files (x86)\7-Zip\7zFM.exe"
	} else {
		Send, %BatchDir%\shortcut.exe /F:"%AppData%\Microsoft\Windows\Start Menu\Programs\7-Zip File Manager.lnk" /A:c /T:"%SystemDrive%\Program Files\7-Zip\7zFM.exe"
	}
	
	Send, {Enter}
	Sleep, 3000
	log(standardStep, "Added 7-Zip icon to the Start Screen")
	
	Process, Close, %PID%
	Sleep, 1000
	
	standardStep = 16
	updateLine(3, standardStep)
}

;;
; Step 16 - Prepare application for use
;           in the qauser account
;           (We're not counting this)
; --------------------------------------
;

if (standardStep = 16) {
	standardStep = 17
	updateLine(3, standardStep)
	updateLine(1, 5)
	
	SoundBeep, 750, 1500
	MsgBox, 0, Finished Setting up the Standard User Account, The program has finished setting up the Standard User account. Your computer will now sign out of the standard account. Please log in as qauser.
	Shutdown, 4
	Pause
}