REM    Thank you: http://community.spiceworks.com/scripts/show/1541-download-and-install-the-latest-version-of-adobe-reader-with-a-batch-file

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::         Download and Install Latest Reader.bat            ::
::                         V2.1                              ::
::                                                           ::
::                     Josiah Kerley                         ::
::                      10/15/2009                           ::
::                                                           ::
::     This script goes out, downloads and installs/updates  ::
::  the latest version of Adobe Reader for Windows           ::
::  automatically without any special programs.  This has    ::
::  tested succesfull on Windows Vista 32bit with            ::
::  Reader version 9.x.                                      ::
::                                                           ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off
	cls
	setlocal enabledelayedexpansion
	:: Options
	set installerFileName=LatestReader.exe
	set keepFile=false
	set cleanLinks=true
	:: Build Menu
	echo cls>menu.bat
	echo echo.>>menu.bat
	echo echo %%*>>menu.bat
	echo echo =========================>>menu.bat
	echo echo.>>menu.bat
	echo echo.>>menu.bat
	echo echo.>>menu.bat
	echo title %%*>>menu.bat
	:: Get Reader Directory from Adobe
	call menu.bat Getting Whole Version
	echo open ftp.adobe.com>Reader.ftp
	echo anonymous>>Reader.ftp
	echo anonymous>>Reader.ftp
	echo cd pub/adobe/reader/win>>Reader.ftp
	echo dir>>Reader.ftp
	echo quit>>Reader.ftp
	ftp -s:Reader.ftp >ftp.tmp
	:: Filter out FTP return to just files/folders
	type ftp.tmp | findstr drwxrwxr >ftp.txt
	for /f "tokens=9 delims= " %%1 in (ftp.txt) do echo %%1>>versions.tmp
	:: Filter down to only version numbers
	type versions.tmp | findstr [0-9]>versions.txt
	del versions.tmp
	for /f "tokens=1 delims=." %%1 in (versions.txt) do echo %%1>>versions.tmp
	del versions.txt
	:: Get rid of erronious "x" files
	type versions.tmp | findstr /v [a-z]>versions.txt
	:: Determine latest version
	for /l %%1 in (1,1,11) do (
		for /f %%a in (versions.txt) do if "%%a" == "%%1" echo %%1>versions.tmp
	)
	:: Load latest full version into variable
	set /p fullVer=<versions.tmp
	:: FTP again but return dot version folders
	call menu.bat Getting Dot Version
	echo open ftp.adobe.com>Reader.ftp
	echo anonymous>>Reader.ftp
	echo anonymous>>Reader.ftp
	echo cd pub/adobe/reader/win/%fullVer%.x>>Reader.ftp
	echo dir>>Reader.ftp
	echo quit>>Reader.ftp
	ftp -s:Reader.ftp >ftp.tmp
	:: Same as before filtering down to latest dot version
	type ftp.tmp | findstr drwxrwxr >ftp.txt
	for /f "tokens=9 delims= " %%1 in (ftp.txt) do echo %%1>>versions.tmp
	type versions.tmp | findstr [0-9]>versions.txt
	for /f %%1 in (versions.txt) do echo %%1>versions.tmp
	:: Setting latest dot veriosn to variable
	set /p subVer=<versions.tmp
	:: More FTP, now getting the actual installer.
	call menu.bat Downloading Installer
	echo open ftp.adobe.com>Reader.ftp
	echo anonymous>>Reader.ftp
	echo anonymous>>Reader.ftp
	echo cd pub/adobe/reader/win/%fullVer%.x/%subVer%/en_US>>Reader.ftp
	echo dir>>Reader.ftp
	echo quit>>Reader.ftp
	ftp -s:Reader.ftp >ftp.tmp
	type ftp.tmp | findstr rwxrwxr >ftp.txt
	for /f "tokens=9 delims= " %%1 in (ftp.txt) do echo %%1>versions.tmp
	set /p getFile=<versions.tmp
	echo open ftp.adobe.com>Reader.ftp
	echo anonymous>>Reader.ftp
	echo anonymous>>Reader.ftp
	echo cd pub/adobe/reader/win/%fullVer%.x/%subVer%/en_US>>Reader.ftp
	echo get %getFile% "%installerFileName%">>Reader.ftp
	echo quit>>Reader.ftp
	ftp -s:Reader.ftp >ftp.tmp
	:: Install
	call menu.bat Installing Adobe Reader %subVer%
	"%installerFileName%" /msi /norestart /quiet 
	:: Cleanup
	call menu.bat Cleaning Up
	if "%cleanLinks%"=="true" for /f "usebackq delims==" %%1 in (`dir /b /s "%HOMEDRIVE%\Users" ^| findstr "Adobe Reader" ^| findstr .lnk`) do del /q "%%1"
	del ftp.tmp
	del ftp.txt
	del Reader.ftp
	del versions.tmp
	del versions.txt
	del menu.bat
	if "%keepFile%"=="false" del LatestReader.exe
	cls
@echo on