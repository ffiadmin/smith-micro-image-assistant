; Hide the GUI and begin the macro script
Gui, Hide

;;
; Step 1 - Activate Windows
; --------------------------------------
;

;RunWait, slmgr /upk
log("1", "Uninstalled product key")
MsgBox, slmgr /ipk %activationKey%
log("1", "Installed product key and activated Windows")