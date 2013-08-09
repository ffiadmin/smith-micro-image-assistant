; Mark the "Start" item on the step menu as completed
GuiControl, Hide, StartHead
GuiControl, +cGreen, StartHead
GuiControl, Show, StartHead

; Mark the "Setup" item on the step menu as completed
GuiControl, Hide, SetupHead
GuiControl, +cGreen, SetupHead
GuiControl, Show, SetupHead

; Highlight the "Administrator" item on the step menu
GuiControl, Hide, AdminHead
GuiControl, +cBlack, AdminHead
GuiControl, Show, AdminHead
GuiControl, Move, Highlight1, w124 x137
GuiControl, Move, Highlight2, w124 x137
GuiControl, Move, Highlight3, w124 x137

; Create a new block to extend the visual size of the background near the bottom of the GUI
Gui, Add, Progress, backgroundCCCCCC disabled h200 w440 x0 y570

; Add the body text to the GUI window
Gui, Add, Text, backgroundTrans vAdminText w400 x20 y120, This program will now set up the administrator account.`n`nWhile the program is running, DO NOT:`n`n`n         Move the mouse.`n`n         Press the keyboard buttons.`n`n         Power off or unplug the machine.`n`n         Unplug the Ethernet cable.`n`n`n`While the program is running, it may sound an alarm to:`n`n`n         Prompt you to log in as qauser or the standard           user after a restart.`n`n         Notify you that the program is finished.

; Add the "X" icons beside the first four unordered list items
Gui, Add, Picture, h21 vRedX6 w21 x35 y229, assets/images/x.jpg
Gui, Add, Picture, h21 vRedX7 w21 x35 y265, assets/images/x.jpg
Gui, Add, Picture, h21 vRedX8 w21 x35 y301, assets/images/x.jpg
Gui, Add, Picture, h21 vRedX9 w21 x35 y337, assets/images/x.jpg

; Add the check mark icons beside the last two unordered list items
Gui, Add, Picture, h21 vCheck6 w21 x35 y463, assets/images/check.jpg
Gui, Add, Picture, h21 vCheck7 w21 x35 y515, assets/images/check.jpg

; Display the time out before the macro begins
Gui, Font, c333333 s12 w600, Verdana
Gui, Add, Text, backgroundTrans vTimeOutHeader x155 y610, Starting in ...
GuiControl, Hide, TimeOutHeader
GuiControl, Show, TimeOutHeader

Gui, Font, c333333 s50 w100, Verdana
Gui, Add, Text, backgroundTrans Center Center vTimeOutValue w300 x65 y640, 30
GuiControl, Hide, TimeOutValue
GuiControl, Show, TimeOutValue

; Run the count down timer
Loop, %CountDownSec% {
	Sleep, 1000
	
	GuiControl, , TimeOutValue, % CountDownSec - A_Index
}