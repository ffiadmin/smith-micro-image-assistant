#SingleInstance Force
#Include config.ahk
#Include lib.ahk

; Ensure that this program is being run as the administrator
if (!A_IsAdmin && A_Username != "standard") {
	Run *RunAs %A_ScriptFullPath%
	ExitApp
}

; Gather information from the program configuration file
step := fetchStep()
adminStep := fetchAdminStep()
standardStep := fetchStdStep()
OSName := fetchOSName()
OSType := fetchOSType()
OSKey := fetchOSKey()
timeZone := fetchTimeZone()

; Create the GUI Object
Gui, -SysMenu

; Create the header
Gui, Add, Progress, background333333 disabled h56 w440 x0 y0
Gui, Add, Picture, h31 w33 x15 y13, %A_ScriptDir%\assets\images\icon-large.jpg
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

; Get ready to execute the inspector
tracking = 0
SetTimer, WatchCursor, 10

; Load the Start page
Step1:
if (step = 1) {
	#Include start.ahk
	GoSub, Step2
	return
}

; Load the Setup page
Step2:
if (step = 2) {
	#Include setup.ahk
	GoSub, Step3
	return
}

; Load the Administrator page and macro script
Step3:
if (step = "3") {
	#Include administrator-gui.ahk
	#Include administrator-macro.ahk
	GoSub, Step4
	return
}

; Load the Standard user page and macro script
Step4:
if (step = "4") {
	#Include standard-gui.ahk
	#Include standard-macro.ahk
	GoSub, Step5
	return
}

; Load the Finish page
Step5:
if (step = "5") {
	#Include finish.ahk
	return
}

; Toggle the cursor inspector
#I::
	if (tracking = 1) {
		tracking = 0
	} else {
		tracking = 1
	}
return

; Display a tooltip, following the cursor, with its coordinates
WatchCursor:
	if (tracking = 1) {
	; Screen position
		CoordMode, Mouse, Screen
		MouseGetPos, ScrX, ScrY
	
	; Window position
		CoordMode, Mouse, Relative
		MouseGetPos, WinX, WinY
		
	; Window top-center position
		CoordMode, Mouse, Relative
		WinGetPos, , , Width, Height, A
		MouseGetPos, MouseX, MouseY
		
		TCMouseX := MouseX - Round(Width / 2)
		TCMouseY := MouseY
		
	; Window top-right position
		TRMouseX := Width - MouseX
		TRMouseY := MouseY
		
	; Window bottom-left position
		BLMouseX := MouseX
		BLMouseY := Height - MouseY
		
	; Window bottom-center position
		BCMouseX := MouseX - Round(Width / 2)
		BCMouseY := Height - MouseY
		
	; Window bottom-right position
		BRMouseX := Width - MouseX
		BRMouseY := Height - MouseY
		
		ToolTip, Screen                  X: %ScrX% Y: %ScrY%`nWindow               X: %WinX% Y: %WinY%`nTop Center          X: %TCMouseX% Y: %TCMouseY%`nTop Right             X: %TRMouseX% Y: %TRMouseY%`nBottom Left         X: %BLMouseX% Y: %BLMouseY%`nBottom Center    X: %BCMouseX% Y: %BCMouseY%`nBottom Right       X: %BRMouseX% Y: %BRMouseY%
	} else {
		ToolTip
	}
return