C:
cd "%APPDATA%\Microsoft\Windows\Start Menu\Programs"
del "regedit.lnk"
move "regedit (2).lnk" "Registry Editor.lnk"
move "mspaint.lnk" "Paint.lnk"
move "notepad.lnk" "notepad-temp.lnk"
move "notepad-temp.lnk" "Notepad.lnk"