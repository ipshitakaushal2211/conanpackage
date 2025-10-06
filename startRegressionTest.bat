set datetimef=%date%_%time:~0,8%
set "datetimef=%datetimef::=_%"
set "datetimef=%datetimef:/=_%"
set "datetimef=%datetimef:.=_%"
set "datetimef=%datetimef: =_%"

if not exist "RegressionTestResult\" md "RegressionTestResult\"
mkdir RegressionTestResult\"ResultArtifacts"

set workspaceOutputTxtPath="RegressionTestResult\ResultArtifacts\CommandLineOutput.txt"
set workspaceXmlOutPath="RegressionTestResult\ResultArtifacts\TestResult.xml"
set workspaceHtmlOutPath="RegressionTestResult\ResultArtifacts\TestResult.html"
set targetIP=%2%
set configuration=%3%
set loop=%4%
set target=%5%
IF [%2] == [] (
set targetIP=10.0.0.2
)

IF [%3] == [] (
set configuration=simulator
)

if not exist "\SpecflowTestReports\" md "\SpecflowTestReports\"

set localOutputTxtPath="\SpecflowTestReports\testOutput%datetimef%.txt"
set localXmlOutPath="\SpecflowTestReports\TestResult%datetimef%.xml"
set localHtmlOutPath="\SpecflowTestReports\TestResult%datetimef%.html"

set specFlowTestsDllPath="..\Output\IWTestAutomation\Philips.IWTestAutomation.dll"

Echo [INFO] %datetimef% : Start SpecflowTest via ..\Output\IWTestAutomation
if [%1] == [] (
	"C:\Program Files (x86)\NUnit.org\nunit-console\nunit3-console.exe" --labels=OnOutputOnly --process=Single --out=%workspaceOutputTxtPath% --result:%workspaceXmlOutPath%;format=nunit2 %specFlowTestsDllPath%
	goto END
)
:: two lines below parse comma separated input tags/categories into format parsable by nunit 3.
set raw_categories=%1
set categories=cat==%raw_categories:,= || cat==%
"C:\Program Files (x86)\NUnit.org\nunit-console\nunit3-console.exe" --labels=OnOutputOnly --process=Separate --where %categories% --out=%workspaceOutputTxtPath% --result:%workspaceXmlOutPath%;format=nunit2 %specFlowTestsDllPath%

REM taskkill /IM Philips.IGT.Simulator* /F
REM taskkill /IM Philips.IGT.ProcedureCard.Editor* /F
REM taskkill /IM Nunit-Agent* /F

:: replace => with ***** to enable specflow to parse feature steps properly
powershell -Command "(gc '%workspaceOutputTxtPath%') | ForEach-Object { $_ -replace '=>', '*****' } | Set-Content '%workspaceOutputTxtPath%'"

Echo [INFO] %datetimef% : Start generating html results
"..\Output\Tools\SpecFlowTools\specflow.exe" nunitexecutionreport "..\Output\Tools\IWTestAutomation.csproj" /testOutput:%workspaceOutputTxtPath% /xmlTestResult:%workspaceXmlOutPath% /out:%workspaceHtmlOutPath%

copy /y %workspaceOutputTxtPath% %localOutputTxtPath%
copy /y %workspaceXmlOutPath% %localXmlOutPath%
copy /y %workspaceHtmlOutPath% %localHtmlOutPath%

SET ROOT=%~dp0\RegressionTestResult\ResultArtifacts
SET TARGETPATH=%~dp0\RegressionTestResult

ROBOCOPY %ROOT% %TARGETPATH% *.* /E /R:5 /W:3

:END
