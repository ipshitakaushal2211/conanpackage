@echo off
echo === Starting Build Process ===

REM Step 1: Create and move into the build directory
mkdir build
cd build

REM Step 2: Run CMake to configure the project
cmake ..

REM Step 3: Build the project
cmake --build .

REM Step 4: Go back to repo root
cd ..

REM Step 5: Create output folder and simulate end state file
mkdir output
echo End state file > output\end_state.txt

REM Step 6: Create package_contents folder
mkdir package_contents

REM Step 7: Copy build folder into package_contents
xcopy /E /I build package_contents\build

REM Step 8: Copy output folder into package_contents
xcopy /E /I output package_contents\output

echo === Build and Packaging Preparation Complete ===
