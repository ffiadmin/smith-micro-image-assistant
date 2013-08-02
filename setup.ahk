; Mark the "Start" item on the step menu as completed
GuiControl, Hide, StartHead
GuiControl, +cGreen, StartHead
GuiControl, Show, StartHead

; Highlight the "Setup" item on the step menu
GuiControl, Hide, SetupHead
GuiControl, +cBlack, SetupHead
GuiControl, Show, SetupHead
GuiControl, Move, Highlight1, w53 x75
GuiControl, Move, Highlight2, w53 x75
GuiControl, Move, Highlight3, w53 x75

; Add the body text to the GUI window
Gui, Add, Text, backgroundTrans vSetupText w400 x20 y120, Below is a listing of information the program will need while configuring the operating system.

; Operating system name input
Gui, Add, Text, backgroundTrans vOSNameText w400 x20 y180, OS Name:
Gui, Add, DropDownList, vOSNameInput w310 x110 y178, Windows 7||

; Operating system type input, 32 or 64-bit
Gui, Add, Text, backgroundTrans vOSTypeText w400 x20 y220, OS Type:
Gui, Add, DropDownList, vOSTypeInput w310 x110 y218, 64-bit||32-bit

; Operating system Activation Key
Gui, Add, Text, backgroundTrans vOSKeyText w400 x20 y260, Key:
Gui, Add, Edit, vOSKeyInput w310 x110 y257
Gui, Font, cGray s10, Verdana
Gui, Add, Text, backgroundTrans vTipText w400 x110 y285, Leave blank to keep current Activation Key`nKey is case sensitive, and requires dashes
Gui, Font
Gui, Font, s11, Verdana

; System time zone
Gui, Add, Text, backgroundTrans vTimeZoneText w400 x20 y335, Time zone:
Gui, Add, DropDownList, vTimeZoneInput w310 x110 y332, Pacific Standard Time|Mountain Standard Time|Central Standard Time|Eastern Standard Time||Central Europe Standard Time

; Add the "Continue" button
Gui, Add, Button, gSetupCont vSetupBtn w400 x20 y721, Continue

; Halt script execution
return

; Continue script execution when "Continue" is clicked
SetupCont:
MsgBox, 4, Smith Micro Image Assistant Confirmation, Please ensure that the information you have entered into this step is correct. Once the program starts, you will not be able to make corrections.`n`nDo you wish to continue?

IfMsgBox, Yes
{
; Remove the components on this page
	Gui, Submit, NoHide

	GuiControl, Hide, SetupHead
	GuiControl, +cGreen, SetupHead
	GuiControl, Show, SetupHead

	GuiControl, Hide, SetupText
	
	GuiControl, Hide, OSNameText
	GuiControl, Hide, OSNameInput
	
	GuiControl, Hide, OSTypeText
	GuiControl, Hide, OSTypeInput
	GuiControl, Hide, TipText
	
	GuiControl, Hide, OSKeyText
	GuiControl, Hide, OSKeyInput
	
	GuiControl, Hide, TimeZoneText
	GuiControl, Hide, TimeZoneInput
	
	GuiControl, Hide, SetupBtn

; Create a text file to save all of the contents of this page
	FileDelete, %ConfigFileLoc%
	FileAppend, 3`n1`n1`n%OSNameInput%`n%OSTypeInput%`n%OSKeyInput%`n%TimeZoneInput%, %ConfigFileLoc%
} else
	return