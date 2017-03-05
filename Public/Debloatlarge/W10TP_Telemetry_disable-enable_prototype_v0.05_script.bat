@ECHO OFF
pushd "%~dp0" & cd /d "%~dp0"
:elevate permission line
(NET FILE||(powershell -command Start-Process '%0' -Verb runAs -ArgumentList '%* '&EXIT /B))>NUL 2>NUL
 
:color and title
color 1f
title W10TP Telemetry disable/enable prototype v0.05 script -deagles and murphy78
 
:Check for Correct Windows Version
ver | find "10.0"
if %ERRORLEVEL% == 0 goto :MAINMENU
Goto :WrongVer
 
:MAINMENU
CLS
ECHO ===============================================================================
ECHO.                                 MAIN MENU
ECHO ===============================================================================
ECHO.        C. - ^(C^)ert Revoke Enable.
ECHO.        D. - ^(D^)nable Telemetry tracking.
ECHO.        E. - ^(E^)nable Telemetry tracking and restore defaults.
ECHO.        H. - ^(H^)osts file add/block telemetry servers.
ECHO.        R. - ^(R^)estore the default Cert status.
ECHO.        U. - ^(U^)nblock the hosts file telemetry servers.
ECHO.        Q. - ^(Q^)uit.
ECHO ===============================================================================
choice /c cdehruq /n /m "Choose a menu option, or Q to Quit: "
SET ERRORTEMP=%ERRORLEVEL%
IF %ERRORTEMP% EQU 1 (GOTO :SelectionC)
IF %ERRORTEMP% EQU 2 (GOTO :SelectionD)
IF %ERRORTEMP% EQU 3 (GOTO :SelectionE)
IF %ERRORTEMP% EQU 4 (GOTO :SelectionH)
IF %ERRORTEMP% EQU 5 (GOTO :SelectionR)
IF %ERRORTEMP% EQU 6 (GOTO :SelectionU)
IF %ERRORTEMP% EQU 7 (GOTO :ABORT)
GOTO :MAINMENU
 
:SelectionC
ECHO ===============================================================================
Echo.              Adding security certs to the disallow list:
ECHO ===============================================================================
 
certutil -addstore -f "Disallowed" "%~dp0msitwww2.crt" >NUL 2>NUL
IF %ERRORLEVEL% NEQ 0 (
echo Encountered errors adding msitwww2.crt to the Disallowed list
pause&goto :MAINMENU
) else (
echo msitwww2.crt added to the Disallowed list success
)
 
certutil -addstore -f "Disallowed" "%~dp0MicSecSerCA2011_2011-10-18.crt" >NUL 2>NUL
IF %ERRORLEVEL% NEQ 0 (
echo Encountered errors adding MicSecSerCA2011_2011-10-18.crt to the Disallowed list
pause&goto :MAINMENU
) else (
echo MicSecSerCA2011_2011-10-18.crt added to the Disallowed list success
)
ECHO ===============================================================================
echo Press any key to return to the menu
pause>NUL 2>NUL
goto :MAINMENU
 
:SelectionD
ECHO ===============================================================================
Echo.              Setting Telemetry registry items to disabled status:
ECHO ===============================================================================
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" "Disabled" 1
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" "DisableAutomaticTelemetryKeywordReporting" 1
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" "TelemetryServiceDisabled" 1
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\TestHooks" "DisableAsimovUpload" 1
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\PerfTrack" "Disabled" 1
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SQMClient\Windows" "CEIPEnable" 0
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" "Start" 0
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener\{22FB2CD6-0E7B-422B-A0C7-2FAD1FD0E716}">NUL 2>NUL
IF %ERRORLEVEL% EQU 0 (call :RegistryAddDword "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener\{22FB2CD6-0E7B-422B-A0C7-2FAD1FD0E716}" "Enabled" 0)
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener\{331C3B3A-2005-44C2-AC5E-77220C37D6B4}">NUL 2>NUL
IF %ERRORLEVEL% EQU 0 (call :RegistryAddDword "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener\{331C3B3A-2005-44C2-AC5E-77220C37D6B4}" "Enabled" 0)
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener\{44345799-E748-4607-9ACF-35306808422C}">NUL 2>NUL
IF %ERRORLEVEL% EQU 0 (call :RegistryAddDword "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener\{44345799-E748-4607-9ACF-35306808422C}" "Enabled" 0)
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener\{96F4A050-7E31-453C-88BE-9634F4E02139}">NUL 2>NUL
IF %ERRORLEVEL% EQU 0 (call :RegistryAddDword "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener\{96F4A050-7E31-453C-88BE-9634F4E02139}" "Enabled" 0)
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener\{DBE9B383-7CF3-4331-91CC-A3CB16A3B538}">NUL 2>NUL
IF %ERRORLEVEL% EQU 0 (call :RegistryAddDword "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener\{DBE9B383-7CF3-4331-91CC-A3CB16A3B538}" "Enabled" 0)
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DiagTrack" "Start" 4
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\dmwappushsvc" "Start" 4
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Wecsvc" "Start" 4
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog" "Start" 4
net stop DiagTrack
net stop dmwappushsvc
net stop Wecsvc
net stop EventLog
ECHO ===============================================================================
Echo.           No errors were reported by the system, going to reboot...
ECHO ===============================================================================
GOTO :QUIT
 
:SelectionE
ECHO ===============================================================================
Echo.              Setting Telemetry registry items to enabled status:
ECHO ===============================================================================
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" "Disabled" 0
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" "DisableAutomaticTelemetryKeywordReporting" 0
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" "TelemetryServiceDisabled" 0
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\TestHooks" "DisableAsimovUpload" 0
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\PerfTrack" "Disabled" 0
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SQMClient\Windows" "CEIPEnable" 1
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" "Start" 1
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener\{22FB2CD6-0E7B-422B-A0C7-2FAD1FD0E716}">NUL 2>NUL
IF %ERRORLEVEL% EQU 0 (call :RegistryAddDword "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener\{22FB2CD6-0E7B-422B-A0C7-2FAD1FD0E716}" "Enabled" 1)
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener\{331C3B3A-2005-44C2-AC5E-77220C37D6B4}">NUL 2>NUL
IF %ERRORLEVEL% EQU 0 (call :RegistryAddDword "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener\{331C3B3A-2005-44C2-AC5E-77220C37D6B4}" "Enabled" 1)
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener\{44345799-E748-4607-9ACF-35306808422C}">NUL 2>NUL
IF %ERRORLEVEL% EQU 0 (call :RegistryAddDword "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener\{44345799-E748-4607-9ACF-35306808422C}" "Enabled" 1)
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener\{96F4A050-7E31-453C-88BE-9634F4E02139}">NUL 2>NUL
IF %ERRORLEVEL% EQU 0 (call :RegistryAddDword "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener\{96F4A050-7E31-453C-88BE-9634F4E02139}" "Enabled" 1)
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener\{DBE9B383-7CF3-4331-91CC-A3CB16A3B538}">NUL 2>NUL
IF %ERRORLEVEL% EQU 0 (call :RegistryAddDword "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener\{DBE9B383-7CF3-4331-91CC-A3CB16A3B538}" "Enabled" 1)
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DiagTrack" "Start" 2
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\dmwappushsvc" "Start" 2
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Wecsvc" "Start" 2
call :RegistryAddDword "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog" "Start" 2
net start DiagTrack
net start dmwappushsvc
net start Wecsvc
net start EventLog
ECHO ===============================================================================
Echo.           No errors were reported by the system, going to reboot...
ECHO ===============================================================================
GOTO :QUIT
 
:SelectionH
ECHO ===============================================================================
Echo.             Adding telemetry blocks to the hosts file:
ECHO ===============================================================================
call :Add-Hosts-Line-Function 0.0.0.0 a-0001.a-msedge.net
call :Add-Hosts-Line-Function 0.0.0.0 a1621.g.akamai.net
call :Add-Hosts-Line-Function 0.0.0.0 a1856.g2.akamai.net
call :Add-Hosts-Line-Function 0.0.0.0 a1961.g.akamai.net
call :Add-Hosts-Line-Function 0.0.0.0 a248.e.akamai.net
call :Add-Hosts-Line-Function 0.0.0.0 cdnjs.cloudflare.com.cdn.cloudflare.net
call :Add-Hosts-Line-Function 0.0.0.0 cdp1.public-trust.com
call :Add-Hosts-Line-Function 0.0.0.0 compatexchange.cloudapp.net
call :Add-Hosts-Line-Function 0.0.0.0 corpext.msitadfs.glbdns2.microsoft.com
call :Add-Hosts-Line-Function 0.0.0.0 cs1.wpc.v0cdn.net
call :Add-Hosts-Line-Function 0.0.0.0 e2835.dspb.akamaiedge.net
call :Add-Hosts-Line-Function 0.0.0.0 e7341.g.akamaiedge.net
call :Add-Hosts-Line-Function 0.0.0.0 e7502.ce.akamaiedge.net
call :Add-Hosts-Line-Function 0.0.0.0 e8218.ce.akamaiedge.net
call :Add-Hosts-Line-Function 0.0.0.0 fe2.update.microsoft.com.akadns.net
call :Add-Hosts-Line-Function 0.0.0.0 fe2.ws.microsoft.com.nsatc.net
call :Add-Hosts-Line-Function 0.0.0.0 hostedocsp.globalsign.com
call :Add-Hosts-Line-Function 0.0.0.0 lb1.www.ms.akadns.net
call :Add-Hosts-Line-Function 0.0.0.0 li581-132.members.linode.com
call :Add-Hosts-Line-Function 0.0.0.0 schemas.microsoft.akadns.net
call :Add-Hosts-Line-Function 0.0.0.0 settings-sandbox.data.microsoft.com
call :Add-Hosts-Line-Function 0.0.0.0 sls.update.microsoft.com.akadns.net
call :Add-Hosts-Line-Function 0.0.0.0 vortex-sandbox.data.microsoft.com
call :Add-Hosts-Line-Function 0.0.0.0 vortex.data.microsoft.com
call :Add-Hosts-Line-Function 0.0.0.0 www.go.microsoft.akadns.net
route add -p 65.39.117.230 0.0.0.0>NUL 2>NUL
if %ERRORLEVEL% NEQ 0 (echo error adding null route to: 65.39.117.230&pause)
route add -p 134.170.30.202 0.0.0.0>NUL 2>NUL
if %ERRORLEVEL% NEQ 0 (echo error adding null route to: 134.170.30.202&pause)
call ipconfig /flushdns>NUL
echo Press any key to return to the Main Menu
pause>NUL&goto :MAINMENU
 
:SelectionR
ECHO ===============================================================================
Echo.             Deleting security certs from the disallow list:
ECHO ===============================================================================
 
certutil -delstore "Disallowed" "%~dp0msitwww2.crt" >NUL 2>NUL
IF %ERRORLEVEL% NEQ 0 (
echo Encountered errors deleting msitwww2.crt from the Disallowed list
pause&goto :MAINMENU
) else (
echo msitwww2.crt deleted from the Disallowed list success
)
 
certutil -delstore "Disallowed" "%~dp0MicSecSerCA2011_2011-10-18.crt" >NUL 2>NUL
IF %ERRORLEVEL% NEQ 0 (
echo Encountered errors deleting MicSecSerCA2011_2011-10-18.crt from the Disallowed list
pause&goto :MAINMENU
) else (
echo MicSecSerCA2011_2011-10-18.crt deleted from the Disallowed list success
)
ECHO ===============================================================================
echo Press any key to return to the menu
pause>NUL 2>NUL
goto :MAINMENU
 
:SelectionU
ECHO ===============================================================================
Echo.             Removing telemetry blocks to the hosts file:
ECHO ===============================================================================
call :Remove-Hosts-Line-Function 0.0.0.0 a-0001.a-msedge.net
call :Remove-Hosts-Line-Function 0.0.0.0 a1621.g.akamai.net
call :Remove-Hosts-Line-Function 0.0.0.0 a1856.g2.akamai.net
call :Remove-Hosts-Line-Function 0.0.0.0 a1961.g.akamai.net
call :Remove-Hosts-Line-Function 0.0.0.0 a248.e.akamai.net
call :Remove-Hosts-Line-Function 0.0.0.0 cdnjs.cloudflare.com.cdn.cloudflare.net
call :Remove-Hosts-Line-Function 0.0.0.0 cdp1.public-trust.com
call :Remove-Hosts-Line-Function 0.0.0.0 compatexchange.cloudapp.net
call :Remove-Hosts-Line-Function 0.0.0.0 corpext.msitadfs.glbdns2.microsoft.com
call :Remove-Hosts-Line-Function 0.0.0.0 cs1.wpc.v0cdn.net
call :Remove-Hosts-Line-Function 0.0.0.0 e2835.dspb.akamaiedge.net
call :Remove-Hosts-Line-Function 0.0.0.0 e7341.g.akamaiedge.net
call :Remove-Hosts-Line-Function 0.0.0.0 e7502.ce.akamaiedge.net
call :Remove-Hosts-Line-Function 0.0.0.0 e8218.ce.akamaiedge.net
call :Remove-Hosts-Line-Function 0.0.0.0 fe2.update.microsoft.com.akadns.net
call :Remove-Hosts-Line-Function 0.0.0.0 fe2.ws.microsoft.com.nsatc.net
call :Remove-Hosts-Line-Function 0.0.0.0 hostedocsp.globalsign.com
call :Remove-Hosts-Line-Function 0.0.0.0 lb1.www.ms.akadns.net
call :Remove-Hosts-Line-Function 0.0.0.0 li581-132.members.linode.com
call :Remove-Hosts-Line-Function 0.0.0.0 schemas.microsoft.akadns.net
call :Remove-Hosts-Line-Function 0.0.0.0 settings-sandbox.data.microsoft.com
call :Remove-Hosts-Line-Function 0.0.0.0 sls.update.microsoft.com.akadns.net
call :Remove-Hosts-Line-Function 0.0.0.0 vortex-sandbox.data.microsoft.com
call :Remove-Hosts-Line-Function 0.0.0.0 vortex.data.microsoft.com
call :Remove-Hosts-Line-Function 0.0.0.0 www.go.microsoft.akadns.net
route DELETE 65.39.117.230>NUL 2>NUL
route DELETE 134.170.30.202>NUL 2>NUL
ipconfig /flushdns>NUL
echo Press any key to return to the Main Menu
pause>NUL&goto :MAINMENU
 
:RegistryAddDword
IF %1 EQU "" echo No -1 data passed to RegAddDword function&pause&exit
IF %2 EQU "" echo No -2 data passed to RegAddDword function&pause&exit
IF %3 EQU "" echo No -3 data passed to RegAddDword function&pause&exit
REG ADD %1 /v %2 /D %3 /T REG_DWORD /F>NUL 2>NUL
IF %ERRORLEVEL% NEQ 0 echo There were errors reported during the Registry operation&pause&goto :EOF
Echo Set %1 key named %2 with value %3: Success
exit /b
 
 
:WrongVer
:Wrong Version of Windows Detected!
ECHO ===============================================================================
ECHO.                   WRONG WINDOWS VERSION - USE WINDOWS 10
ECHO ===============================================================================
Timeout 3
goto :EOF
 
 
:ABORT
:Your standard Thank you and goodbye screen
ECHO ===============================================================================
ECHO.                          EXITING MENU SCRIPT
ECHO ===============================================================================
Echo Press any key to exit...
pause>NUL&goto :EOF
 
:QUIT
:Your standard Thank you and goodbye screen
ECHO ===============================================================================
ECHO.                          END OF THE LINE MATEY
ECHO -------------------------------------------------------------------------------
ECHO.        Would you like to (R)eboot, (S)hutdown, (M)ain Menu or (Q)uit?
ECHO ===============================================================================
choice /c rsmq /t 20 /d r /n /m "System will reboot after 20 seconds (R/S/M/Q): "
IF %ERRORLEVEL% EQU 1 (Shutdown /r /t 0&exit)
IF %ERRORLEVEL% EQU 2 (Shutdown /s /t 0&exit)
IF %ERRORLEVEL% EQU 3 (goto :MAINMENU)
IF %ERRORLEVEL% EQU 4 (goto :EOF)
goto :EOF
 
:Add-Hosts-Line-Function
IF %1 EQU "" echo :Add-Hosts-Line-Function missing 1st parameter&pause&exit
IF %2 EQU "" echo :Add-Hosts-Line-Function missing 2nd parameter&pause&exit
 
:make copy to work with since system won't let you directly edit hosts file
attrib -h -s "%WinDir%\System32\drivers\etc\hosts" >nul
xcopy /chy "%WinDir%\System32\drivers\etc\hosts" "%TMP%" >nul
 
for /f "delims=" %%h in ('type "%TMP%\hosts" ^| find /c /i "%2"') do (
        set "result=%%h" >nul
        )
 
if "%result%"=="0" (
        >>"%TMP%\hosts" echo %1 %2
        echo %1 %2 added to hosts file
        del /q/f "%WinDir%\System32\drivers\etc\hosts" >nul
        move /y "%TMP%\hosts" "%WinDir%\System32\drivers\etc\hosts" >nul
        attrib +h "%WinDir%\System32\drivers\etc\hosts" >nul
        exit /b
        ) else (
        echo %2 already exists in hosts file
        del /q/f "%TMP%\hosts" >nul
        attrib +h "%WinDir%\System32\drivers\etc\hosts" >nul
        exit /b
        )
::end function
 
:Remove-Hosts-Line-Function
IF %1 EQU "" echo :Remove-Hosts-Line-Function missing 1st parameter&pause&exit
IF %2 EQU "" echo :Remove-Hosts-Line-Function missing 2nd parameter&pause&exit
 
:make copy to work with since system won't let you directly edit hosts file
attrib -h -s "%WinDir%\System32\drivers\etc\hosts" >nul
xcopy /chy "%WinDir%\System32\drivers\etc\hosts" "%TMP%" >nul
 
for /f "delims=" %%h in ('type "%TMP%\hosts" ^| find /c /i "%2"') do (
        set "result=%%h" >nul
        )
if "%result%" geq "1" (
        for /f "tokens=*" %%a in ('findstr /in ".*" "%TMP%\hosts"') do (
                echo %%a>>"%TMP%\l_1.x"
                )
        for /f "eol=# tokens=1,2 delims=:" %%a in ('findstr /i "%2" "%TMP%\l_1.x"') do (
                set stringlines=%%a
                )
        setlocal enabledelayedexpansion
        set /a "beforelines=stringlines-1"
        set /a "afterlines=stringlines+1"
        for /f "eol=# tokens=2* delims=:" %%a in ('findstr /in ".*" "%TMP%\l_1.x"') do (
                if %%a leq !beforelines! echo.%%b>>"%tmp%\l_2.x"
                if %%a geq !afterlines! echo.%%b>>"%tmp%\l_2.x"
                )
        endlocal
        del /q/f "%WinDir%\System32\drivers\etc\hosts" >nul
        move /y "%TMP%\l_2.x" "%WinDir%\System32\drivers\etc\hosts" >nul
        attrib +h "%WinDir%\System32\drivers\etc\hosts" >nul
        del /q/f "%TMP%\hosts" >nul
        del /q/f "%TMP%\*.x" >nul
        echo %2 successfully removed from hosts file
        exit /b
        ) else (
        echo %2 does not exist in hosts file
        del /q/f "%TMP%\hosts" >nul
        del /q/f "%TMP%\*.x" >nul
        attrib +h "%WinDir%\System32\drivers\etc\hosts" >nul
        exit /b
        )
::end function
