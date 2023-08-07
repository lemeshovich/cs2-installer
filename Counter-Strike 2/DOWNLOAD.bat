@if (@CodeSection == @Batch) @then
@echo off
if not "%1" == "max" start /MAX cmd /c %0 max & exit/b
::color 3
SET SendKeys=CScript //nologo //E:JScript "%~F0"
SET AppActivate=CScript //nologo //E:JScript "%~F0"
title CS2 Installer

::Check for required programs (CScript and PowerShell)
where /q CScript || (
    echo CScript is not installed or not in the system PATH. Exiting...
    exit /b 1
)
where /q powershell || (
    echo PowerShell is not installed or not in the system PATH. Exiting...
    exit /b 1
)

echo This script will download latest Counter-Strike 2 limited test build and custom maps...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/CS2-OOF-LV/CS2Installer/releases/download/v2.2/CS2Installer.zip', 'CS2Installer.zip')"
echo Unzipping CS2 installer...
tar -xf CS2Installer.zip
del CS2Installer.zip
rename "%~dp0CS2Installer.exe" "UPDATE.exe"

echo Updating CS2 installer...
%SendKeys% "{ENTER}" | START /B UPDATE.exe> nul 2> nul
TIMEOUT /t 3 /nobreak>nul
%AppActivate% "CS2 Installer"
echo CS2 installer updated.

TIMEOUT /t 2 /nobreak>nul
echo Running CS2 installer...
%AppActivate% "CS2 Installer"
%SendKeys% "y" & %SendKeys% "{ENTER}" | START /wait /B UPDATE.exe

del Start*.bat
echo Downloading patched cs2.exe...
rename "%~dp0game\bin\win64\cs2.exe" "cs2.exe.bak"
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/mikkokko/cs2_patch/releases/download/v2/cs2.exe', '%~dp0game\bin\win64\cs2.exe')"

echo Downloading fy_pool_day...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://files.gamebanana.com/mods/fy_pool_day_10912.zip', 'fy_pool_day.zip')"
echo Unzipping fy_pool_day...
tar -xf fy_pool_day.zip -C %~dp0game\csgo\maps
del fy_pool_day.zip

echo Downloading awp_lego_2_ultimate...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://files.gamebanana.com/mods/awp_lego_2_ultimate_2c97a.zip', 'awp_lego_2_ultimate.zip')"
echo Unzipping awp_lego_2_ultimate...
tar -xf awp_lego_2_ultimate.zip -C %~dp0game\csgo\maps
del awp_lego_2_ultimate.zip

echo Creating desktop shortcuts...
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%userprofile%\Desktop\Counter-Strike 2.lnk');$s.TargetPath='%~dp0game\bin\win64\cs2.exe';$s.Arguments='-language english -condebug -novid -console -insecure +connect 176.36.33.226';$s.IconLocation='%~dp0cs2.ico';$s.Save()"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%userprofile%\Desktop\CS2 Update.lnk');$s.TargetPath='%~dp0UPDATE.exe';$s.WorkingDirectory='%~dp0';$s.IconLocation='%~dp0cs2.ico';$s.Save()"

echo The script done its job.
%AppActivate% "CS2 Installer"
echo Press any key to start the game otherwise close this window...
pause >nul
START %userprofile%"\Desktop\Counter-Strike 2.lnk"

@end
// JScript section
var WshShell = WScript.CreateObject("WScript.Shell");
WshShell.AppActivate(WScript.Arguments(0));0
WshShell.SendKeys(WScript.Arguments(0));0