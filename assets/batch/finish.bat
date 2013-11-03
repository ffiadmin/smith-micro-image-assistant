%SYSTEMDRIVE%

del /Q /F %AppData%\Microsoft\Windows\Start Menu\Programs\Startup\show.scf
del /Q /F %AppData%\Microsoft\Windows\Start Menu\Programs\Startup\start.bat

del /Q /F %SYSTEMDRIVE%\Users\standard\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\show.scf
del /Q /F %SYSTEMDRIVE%\Users\standard\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\start.bat

cd %SYSTEMDRIVE%\AHK
del /Q /F config.db
rmdir /Q /S downloads
rmdir /Q /S theme
rmdir /Q /S batch