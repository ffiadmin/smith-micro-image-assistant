; Highlight the "Start" item on the step menu
GuiControl, Hide, StartHead
GuiControl, +cBlack, StartHead
GuiControl, Show, StartHead
GuiControl, Move, Highlight1, w46 x20
GuiControl, Move, Highlight2, w46 x20
GuiControl, Move, Highlight3, w46 x20

; Add the body text to the GUI window
Gui, Add, Text, backgroundTrans vStartText w400 x20 y120, This program is designed to assist you in building a Windows Operating System image. Before running this program you will need to ensure all of the following steps have already been completed:`n`n`n         Create an initial, factory image.`n`n         Disable User Account Control (UAC).`n`n         Install or update all drivers.`n`n         Verify in the Device Manager that all network              hardware is available for use (LAN, Wi-Fi, etc...)`n`n         Connect to the network via Ethernet.`n`n`n`This program will NOT be able to:`n`n`n         Install, update, or check for missing drivers.`n`n         Generate a background with the machine                   specs and Device Manager screenshot.`n`n         Install third-party software from the                           manufacture.`n`n         Uninstall trial software or bloatware.`n`n         Run msconfig to enable selective start-up.

; Add the check mark icons beside the first five unordered list items
Gui, Add, Picture, h21 vCheck1 w21 x35 y227, %A_ScriptDir%\assets\images\x.jpg
Gui, Add, Picture, h21 vCheck2 w21 x35 y263, %A_ScriptDir%\assets\images\x.jpg
Gui, Add, Picture, h21 vCheck3 w21 x35 y299, %A_ScriptDir%\assets\images\x.jpg
Gui, Add, Picture, h21 vCheck4 w21 x35 y335, %A_ScriptDir%\assets\images\x.jpg
Gui, Add, Picture, h21 vCheck5 w21 x35 y388, %A_ScriptDir%\assets\images\x.jpg

; Add the "X" icons beside the last five unordered list items
Gui, Add, Picture, h21 vRedX1 w21 x35 y498, %A_ScriptDir%\assets\images\check.jpg
Gui, Add, Picture, h21 vRedX2 w21 x35 y535, %A_ScriptDir%\assets\images\check.jpg
Gui, Add, Picture, h21 vRedX3 w21 x35 y588, %A_ScriptDir%\assets\images\check.jpg
Gui, Add, Picture, h21 vRedX4 w21 x35 y641, %A_ScriptDir%\assets\images\check.jpg
Gui, Add, Picture, h21 vRedX5 w21 x35 y678, %A_ScriptDir%\assets\images\check.jpg

; Add the "Continue" button
Gui, Add, Button, gStartCont vStartBtn w400 x20 y721, Continue

; Halt script execution
return

; Continue script execution when "Continue" is clicked
StartCont:
GuiControl, Hide, StartHead
GuiControl, +cGreen, StartHead
GuiControl, Show, StartHead

GuiControl, Hide, StartText

GuiControl, Hide, Check1
GuiControl, Hide, Check2
GuiControl, Hide, Check3
GuiControl, Hide, Check4
GuiControl, Hide, Check5

GuiControl, Hide, RedX1
GuiControl, Hide, RedX2
GuiControl, Hide, RedX3
GuiControl, Hide, RedX4
GuiControl, Hide, RedX5

GuiControl, Hide, StartBtn

; Move onto the next step
step = 2