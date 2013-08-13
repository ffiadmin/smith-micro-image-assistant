C:
cd %PROGRAMFILES%
cd "..\Program Files"
cd "Windows Defender"
MpCmdRun.exe -SignatureUpdate
MpCmdRun.exe -Scan -ScanType 2