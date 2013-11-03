; Show a taskbar balloon indicating the current step
showTip(step, content) {
	TrayTip, Step %step% of 37, %content%, 20000, 1
}

; Add a log entry
log(step, text) {
	global LogLoc
	
	FormatTime, now, , M/d/yyyy h:m:s tt
	FileAppend, %step%`n%now%`n**********************************`n%text%`n`n`n, %LogLoc%
}

; Add a tray tip
tip(stepNum, text, totalNumSteps) {
	TrayTip, Step %stepNum% of %totalNumSteps%, %text%, 20, 1
}

; Fetch the Wizard Step Number from the configuration file
fetchStep() {
	global ConfigFileLoc

	IfExist, %ConfigFileLoc%
	{
		FileReadLine, line, %ConfigFileLoc%, 1
		return line
	} else {
		return 1
	}
}

; Fetch the Administration Step Number from the configuration file
fetchAdminStep() {
	global ConfigFileLoc

	IfExist, %ConfigFileLoc%
	{
		FileReadLine, line, %ConfigFileLoc%, 2
		return line
	} else {
		return 1
	}
}

; Fetch the Standard Step Number from the configuration file
fetchStdStep() {
	global ConfigFileLoc

	IfExist, %ConfigFileLoc%
	{
		FileReadLine, line, %ConfigFileLoc%, 3
		return line
	} else {
		return 1
	}
}

; Fetch the Operating System Name from the configuration file
fetchOSName() {
	global ConfigFileLoc

	IfExist, %ConfigFileLoc%
	{
		FileReadLine, line, %ConfigFileLoc%, 4
		return line
	} else {
		return Windows 8
	}
}

; Fetch the Operating System Type from the configuration file
fetchOSType() {
	global ConfigFileLoc

	IfExist, %ConfigFileLoc%
	{
		FileReadLine, line, %ConfigFileLoc%, 5
		return line
	} else {
		return 64-bit
	}
}

; Fetch the Operating System Key from the configuration file
fetchOSKey() {
	global ConfigFileLoc

	IfExist, %ConfigFileLoc%
	{
		FileReadLine, line, %ConfigFileLoc%, 6
		return line
	} else {
		return 
	}
}

; Fetch the Time Zone from the configuration file
fetchTimeZone() {
	global ConfigFileLoc

	IfExist, %ConfigFileLoc%
	{
		FileReadLine, line, %ConfigFileLoc%, 7
		return line
	} else {
		return "Eastern Standard Time"
	}
}

; Update an entry in the database file
updateLine(lineNum, value) {
	global ConfigFileLoc
	
	line = 

	Loop, Read, %ConfigFileLoc%
	{
		if (A_Index = lineNum) {
			line .= value . "`n"
		} else {
			line .= A_LoopReadLine . "`n"
		}
	}
	
	StringTrimRight, contents, line, 1
	FileDelete, %ConfigFileLoc%
	FileAppend, %contents%, %ConfigFileLoc%
}

; MouseMove with the origin set to the left-top of the active window
mouseMoveLT(X, Y) {
	CoordMode, Mouse, Relative
	MouseMove, X, Y 
}

; MouseMove with the origin set to the center-top of the active window
mouseMoveCT(X, Y) {
	CoordMode, Mouse, Relative
	WinGetPos, , , Width, , A
	
	half := Round(Width / 2)
	MoveX := Width - (half - X)
	
	MouseMove, MoveX, Y 
}

; MouseMove with the origin set to the right-top of the active window
mouseMoveRT(X, Y) {
	CoordMode, Mouse, Relative
	WinGetPos, , , Width, , A
	
	MoveX := Width - X
	
	MouseMove, MoveX, Y 
}

; MouseMove with the origin set to the left-bottom of the active window
mouseMoveLB(X, Y) {
	CoordMode, Mouse, Relative
	WinGetPos, , , , Height, A
	
	MoveY := Height - Y
	
	MouseMove, X, MoveY
}

; MouseMove with the origin set to the center-bottom of the active window
mouseMoveCB(X, Y) {
	CoordMode, Mouse, Relative
	WinGetPos, , , Width, Height, A
	
	half := Round(Width / 2)
	MoveX := Width - (half - X)
	MoveY := Height - Y
	
	MouseMove, MoveX, MoveY
}

; MouseMove with the origin set to the right-bottom of the active window
mouseMoveRB(X, Y) {
	CoordMode, Mouse, Relative
	WinGetPos, , , Width, Height, A
	
	half := Round(Width / 2)
	MoveX := Width - X
	MoveY := Height - Y
	
	MouseMove, MoveX, MoveY
}