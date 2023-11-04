@ECHO OFF
::2021-11-02
set /a _Debug=0

::================================================================================================
:: Run Script as Administrator

set _Args=%*
if "%~1" NEQ "" (
  set _Args=%_Args:"=%
)
fltmc 1>nul 2>nul || (
  cd /d "%~dp0"
  cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~dp0"" && ""%~dpnx0"" ""%_Args%""", "", "runas", 1 > "%temp%\GetAdmin.vbs"
  "%temp%\GetAdmin.vbs"
  del /f /q "%temp%\GetAdmin.vbs" 1>nul 2>nul
  exit
)

::================================================================================================

@SHIFT /0

CLS

TITLE Custom Hosts Editor

color a

ECHO.
ECHO  - Custom Hosts Editor...
ECHO.

:: Allow the user to add a single custom host
ECHO  - Enter your custom host (e.g., "example.com" with double-quotes if it contains spaces):
set /p "customHost="

:: Proceed to edit the hosts file

takeown /f "%SystemRoot%\System32\drivers\etc\hosts" /a

icacls "%SystemRoot%\System32\drivers\etc\hosts" /grant administrators:F

attrib -h -r -s "%SystemRoot%\System32\drivers\etc\hosts"

:: Remove predefined hosts
(FOR /F "tokens=*" %%G IN ('type "%SystemRoot%\system32\drivers\etc\hosts" ^| find /v "license.piriform.com" ^| find /v "www.license.piriform.com" ^| find /v "speccy.piriform.com" ^| find /v "www.speccy.piriform.com" ^| find /v "recuva.piriform.com" ^| find /v "www.recuva.piriform.com" ^| find /v "defraggler.piriform.com" ^| find /v "www.defraggler.piriform.com" ^| find /v "ccleaner.piriform.com" ^| find /v "www.ccleaner.piriform.com" ^| find /v "license-api.ccleaner.com"') DO (
    ECHO %%G
)) > "%SystemRoot%\system32\drivers\etc\hosts.tmp"
MOVE /Y "%SystemRoot%\system32\drivers\etc\hosts.tmp" "%SystemRoot%\system32\drivers\etc\hosts"

SET NEWLINE=^& echo.

:: Add the custom host with the default IP
ECHO 127.0.0.1                   %customHost% >> "%SystemRoot%\system32\drivers\etc\hosts"

attrib +h +r +s "%SystemRoot%\system32\drivers\etc\hosts"

ECHO.
ECHO  - Custom Hosts Editor...
ECHO.
ECHO  - DONE
ECHO.
ECHO  - Press Any Key To Exit ...
timeout -1

@EXIT
