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

; Fetch the Step Number from the configuration file
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