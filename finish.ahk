; Mark the "Start" item on the step menu as completed
GuiControl, Hide, StartHead
GuiControl, +cGreen, StartHead
GuiControl, Show, StartHead

; Mark the "Setup" item on the step menu as completed
GuiControl, Hide, SetupHead
GuiControl, +cGreen, SetupHead
GuiControl, Show, SetupHead

; Mark the "Administrator" item on the step menu as completed
GuiControl, Hide, AdminHead
GuiControl, +cGreen, AdminHead
GuiControl, Show, AdminHead

; Mark the "Standard" item on the step menu as completed
GuiControl, Hide, StandardHead
GuiControl, +cGreen, StandardHead
GuiControl, Show, StandardHead

; Highlight the "Finish" item on the step menu
GuiControl, Hide, FinishHead
GuiControl, +cBlack, FinishHead
GuiControl, Show, FinishHead
GuiControl, Move, Highlight1, w54 x364
GuiControl, Move, Highlight2, w54 x364
GuiControl, Move, Highlight3, w54 x364

; Add the body text to the GUI window
Gui, Add, Text, backgroundTrans vAdminText w400 x20 y120, Your operating system has been set up. You may find the program's log files here:`n`n%LogLoc%`n`nIf you have not done so already, please:`n`n         Uninstall any bloatware apps or desktop                     software.`n`n         Install all necessary drivers.`n`n         Create and apply a machine specification                    desktop background.`n`n         Install all third-party software that came with              the machine.`n`n         Install StuffIT, and start it for the first time for             both qauser and the standard user.`n`n         Disable Adobe and Java start-up applications              from the Task Manager > Startup tab.`n`n         Using Paragon 12, leave at least 3 GB of                    unallocated space at the END of the hard drive.`n`n         Create a Paragon image.`n`nConsult the laptop configuration documentation for details.

; Add the check mark icons beside the last two unordered list items
Gui, Add, Picture, h21 vCheck8 w21 x35 y247, %A_ScriptDir%\assets\images\check.jpg
Gui, Add, Picture, h21 vCheck9 w21 x35 y300, %A_ScriptDir%\assets\images\check.jpg
Gui, Add, Picture, h21 vCheck10 w21 x35 y337, %A_ScriptDir%\assets\images\check.jpg
Gui, Add, Picture, h21 vCheck11 w21 x35 y390, %A_ScriptDir%\assets\images\check.jpg
Gui, Add, Picture, h21 vCheck12 w21 x35 y444, %A_ScriptDir%\assets\images\check.jpg
Gui, Add, Picture, h21 vCheck13 w21 x35 y498, %A_ScriptDir%\assets\images\check.jpg
Gui, Add, Picture, h21 vCheck14 w21 x35 y551, %A_ScriptDir%\assets\images\check.jpg
Gui, Add, Picture, h21 vCheck15 w21 x35 y604, %A_ScriptDir%\assets\images\check.jpg

; Add the "Finish" button
Gui, Add, Button, gFinishCont vFinishBtn w400 x20 y721, Finish

; Halt script execution
return

; Remove all temporary files and start up items
FinishCont:
RunWait, %BatchDir%\finish.bat
ExitApp