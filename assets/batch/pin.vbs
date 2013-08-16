' Thank you: http://social.technet.microsoft.com/Forums/windows/en-US/cd7d7a32-d214-4fbe-8e1c-e0cc7b69d172
Set objShell = CreateObject("Shell.Application")

' Pin to Start Menu - Paint
Set objFolder = objShell.Namespace("C:\Windows\System32")
Set objFolderItem = objFolder.ParseName("mspaint.exe") 
Set colVerbs = objFolderItem.Verbs 
For Each objVerb in colVerbs 
    If Replace(objVerb.name, "&", "") = "Pin to Start" Then objVerb.DoIt ' Windows 7 "Pin to Start Menu"
Next

' Pin to Start Menu - Notepad
Set objFolder = objShell.Namespace("C:\Windows\System32")
Set objFolderItem = objFolder.ParseName("notepad.exe") 
Set colVerbs = objFolderItem.Verbs 
For Each objVerb in colVerbs 
    If Replace(objVerb.name, "&", "") = "Pin to Start" Then objVerb.DoIt ' Windows 7 "Pin to Start Menu"
Next

' Pin to Start Menu - regedit
Set oShell = CreateObject("WScript.Shell")
strHomeFolder = oShell.ExpandEnvironmentStrings("%APPDATA%")

Set objFolder = objShell.Namespace(strHomeFolder & "\Microsoft\Windows\Start Menu\Programs")
Set objFolderItem = objFolder.ParseName("regedit.lnk") 
Set colVerbs = objFolderItem.Verbs 
For Each objVerb in colVerbs 
    If Replace(objVerb.name, "&", "") = "Pin to Start" Then objVerb.DoIt ' Windows 7 "Pin to Start Menu"
Next