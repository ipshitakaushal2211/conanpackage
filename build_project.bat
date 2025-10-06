@echo off
echo === Building Project ===

REM Replace this with your actual build command
REM Example: msbuild MyProject.sln /p:Configuration=Release

echo === Build Complete ===

REM Create a folder to collect files for packaging
mkdir package_contents

REM Copy build folder
xcopy /E /I build package_contents\build

REM Copy output folder
xcopy /E /I output package_contents\output

echo === Files Ready for Packaging ===
