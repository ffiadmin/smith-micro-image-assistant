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