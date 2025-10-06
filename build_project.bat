@echo off
echo === Building C# Project with MSBuild ===

REM Build the Visual Studio solution
msbuild IWTestAutomation.sln /p:Configuration=Release

REM Create output folder and simulate end state file
mkdir output
echo End state file > output\end_state.txt

REM Create package_contents folder
mkdir package_contents

REM Copy build folder (already exists in repo)
xcopy /E /I build package_contents\build

REM Copy output folder (created above)
xcopy /E /I output package_contents\output

echo === Build and Packaging Preparation Complete ===
