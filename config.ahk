; Get the user's system drive (e.g. C: or D:)
EnvGet, A_SystemDrive, SystemDrive

; Program configuration
AdminStepTotal = 27
AppName = Smith Micro Image Assistant
BackgroundColor = FAFAFA
BaseDir = %A_SystemDrive%\AHK
BatchDir = %A_SystemDrive%\AHK\batch
ConfigFileLoc = %A_SystemDrive%\AHK\config.db
CountDownSec = 30
DownloadDir = %A_SystemDrive%\AHK\downloads
LogLoc = %A_SystemDrive%\AHK\progress.log
StandardStepTotal = 15
ThemeDir = %A_SystemDrive%\AHK\theme