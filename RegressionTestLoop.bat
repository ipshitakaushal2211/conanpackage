@echo off

set datetimef=%date%_%time:~0,8%
set "datetimef=%datetimef::=_%"
set "datetimef=%datetimef:/=_%"
set "datetimef=%datetimef:.=_%"
set "datetimef=%datetimef: =_%"

set TagName=%1
set target=%2
set targetIP=%3%
set configuration=%4%
set loop=0

IF [%3] == [] (
set targetIP=10.0.0.2
)

IF [%4] == [] (
set configuration=simulator
)

if not exist "FailureTimestamp\" md "FailureTimestamp\"

:loop
echo Executing iteration number %loop%
set /a loop=%loop%+1 

echo ----------------- Generating all test names to TestNames.txt file------
call startRegressionTest.bat %TagName% %targetIP% %configuration% %loop% %target%  
echo -----------------------------------------------------------------------

if "%loop%"=="%target%" goto next
goto loop

REM timeout 30 >nul
REM taskkill /IM Nunit-Agent* /F

:next
ping -n 9 127.0.0.1 >NUL
echo successfully executed for %target% times.
REM taskkill /IM Philips.IGT.ProcedureCard.Editor* /F
REM taskkill /IM Nunit-Agent* /F