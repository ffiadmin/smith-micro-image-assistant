#SingleInstance Force
#Include config.ahk
#Include lib.ahk

; Ensure that this program is being run as the administrator
if (!A_IsAdmin) {
	Run *RunAs %A_ScriptFullPath%
	ExitApp
}

; Gather information from the program configuration file
line := fetchStep()
activationKey := fetchOSKey()

; Create the GUI Object
Gui, -SysMenu

; Create the header
Gui, Add, Progress, background333333 disabled h56 w440 x0 y0
Gui, Add, Picture, h31 w33 x15 y13, assets/images/icon-large.jpg
Gui, Font, cWhite s12 w100, Verdana
Gui, Add, Text, backgroundTrans x65 y19, %AppName%

; Create the Step Menu
Gui, Font, c808080 s12 w600, Verdana
Gui, Add, Text, backgroundTrans vStartHead x20 y67, Start
Gui, Add, Text, backgroundTrans vSetupHead x75 y67, Setup
Gui, Add, Text, backgroundTrans vAdminHead x137 y67, Administrator
Gui, Add, Text, backgroundTrans vStandardHead x270 y67, Standard
Gui, Add, Text, backgroundTrans vFinishHead x363 y67, Finish
Gui, Add, Text, h1 w20 vHighlight1 y94 0x7
Gui, Add, Text, h1 w20 vHighlight2 y95 0x7
Gui, Add, Text, h1 w20 vHighlight3 y96 0x7
Gui, Add, Text, w450 x0 y97 0x10

; Reset the font styles
Gui, Font
Gui, Font, s11, Verdana

; Create a background for the "Continue" step buttons at the bottom of the GUI
Gui, Add, Progress, backgroundCCCCCC disabled h56 w440 x0 y710

; Show the GUI
Gui, Color, %BackgroundColor%
Gui, Show, center h762 w440, %AppName%

; Load the Start page
if (line = "1") {
	#Include start.ahk
}

; Load the Setup page
if (line = "2") {
	#Include setup.ahk
}

; Load the Administrator page and macro script
if (line = "3") {
	#Include administrator-gui.ahk
	#Include administrator-macro.ahk
}