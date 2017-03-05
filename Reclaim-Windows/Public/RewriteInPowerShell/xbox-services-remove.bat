@echo off

echo XBOX-B-GONE
echo.
echo This will remove the Xbox services from Windows 10.
echo Run this script as admin.
echo.
pause

sc stop XblAuthManager
sc delete XblAuthManager
echo.
sc stop XblGameSave
sc delete XblGameSave
echo.
sc stop XboxNetApiSvc
sc delete XboxNetApiSvc
echo.

pause
