@echo off

cd %~dp0
echo Current Directory = %cd%

:check_os
IF "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set bit=x86
) else (
    set bit=x64
)

:check_sysmon
IF %bit% == "x86" (
    sc query "Sysmon" | Find "RUNNING"
) else (
    sc query "Sysmon64" | Find "RUNNING"
)
IF "%ERRORLEVEL%" NEQ "0" (
    goto start_sysmon
)
goto check_sysmon_version

:start_sysmon
echo Starting sysmon...
IF %bit% == "x86" (
    net start Sysmon
) else (
    net start Sysmon64
)
IF "%ERRORLEVEL%" NEQ "0" (
    goto install_sysmon
)

:check_sysmon_version
IF %bit% == "x86" (
    Sysmon | Find "12.03"
) else (
    Sysmon64 | Find "12.03"
)
IF "%ERRORLEVEL%" NEQ "0" (
    goto install_sysmon
)
goto update_config

:update_config
echo Updating Sysmon Config...
IF %bit% == "x86" (
    sysmon.exe -c sysmonconfig-export.xml
) else (
    sysmon64.exe -c sysmonconfig-export.xml
)
goto exit

:install_sysmon
echo Installing Sysmon Config...
sysmon.exe -u
sysmon64.exe -u
IF %bit% == "x86" (
    sysmon.exe /accepteula -i sysmonconfig-export.xml
) else (
    sysmon64.exe /accepteula -i sysmonconfig-export.xml
)

:exit
echo Completed!
