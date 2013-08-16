REM    Thank you: http://www.catonrug.net/2013/02/get-latest-jre-using-wget-in-windows.html

@echo off
setlocal EnableDelayedExpansion
cd "%~dp0"
set wget=%~dp0wget.exe
set sed=%~dp0sed.exe
set i=%SystemDrive%\AHK\downloads\1.index.log
set url=%SystemDrive%\AHK\downloads\2.jre.download.page.url.log
set page=%SystemDrive%\AHK\downloads\3.jre.download.page.log
set i586=%SystemDrive%\AHK\downloads\4.jre.i586.url.log
set x64=%SystemDrive%\AHK\downloads\5.jre.x64.url.log
"%wget%" http://www.oracle.com/technetwork/java/javase/downloads/index.html -O "%i%"
"%sed%" "s/\d034/\n/g" "%i%" | "%sed%" -n "/jre7/p" | "%sed%" ihttp://www.oracle.com | "%sed%" "N;s/\n//" > "%url%"
for /f "tokens=*" %%a in ('type "%url%"') do "%wget%" %%a -O "%page%"
"%sed%" "s/\d034/\n/g" "%page%" | "%sed%" -n "/i586.exe/p" | "%sed%" -n "/download.oracle/p" > "%i586%"
"%sed%" "s/\d034/\n/g" "%page%" | "%sed%" -n "/x64.exe/p" | "%sed%" -n "/download.oracle/p" > "%x64%"

for /f "tokens=*" %%a in ('type "%i586%"') do for /f "tokens=7 delims=/" %%b in ('echo %%a') do "%wget%" --no-check-certificate --no-cookies --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F" "%%a" -O "%SystemDrive%\AHK\downloads\java-32.exe"
for /f "tokens=*" %%a in ('type "%x64%"') do for /f "tokens=7 delims=/" %%b in ('echo %%a') do "%wget%" --no-check-certificate --no-cookies --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F" "%%a" -O "%SystemDrive%\AHK\downloads\java-64.exe"

endlocal
pause