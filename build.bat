@echo off
setlocal
title TruthLens - Build Script

where javac >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    set JAVAC_CMD=javac
    set JAR_CMD=jar
) else if exist "C:\Program Files\Microsoft\jdk-21.0.13.21-hotspot\bin\javac.exe" (
    set "JAVAC_CMD=C:\Program Files\Microsoft\jdk-21.0.13.21-hotspot\bin\javac.exe"
    set "JAR_CMD=C:\Program Files\Microsoft\jdk-21.0.13.21-hotspot\bin\jar.exe"
) else (
    echo [ERROR] JDK compiler could not be located.
    pause
    exit /b 1
)

echo [1/3] Cleaning and preparing bin directory...
if not exist "%~dp0bin" mkdir "%~dp0bin"

echo [2/3] Compiling Java source files...
powershell -NoProfile -Command "Get-ChildItem -Path '%~dp0src' -Filter *.java -Recurse | ForEach-Object { '\"' + ($_.FullName -replace '\\', '/') + '\"' } | Set-Content '%~dp0sources.txt'"
"%JAVAC_CMD%" -d "%~dp0bin" @"%~dp0sources.txt"
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Compilation failed!
    del "%~dp0sources.txt"
    pause
    exit /b 1
)
del "%~dp0sources.txt"

echo [3/3] Packaging TruthLens.jar...
(
echo Manifest-Version: 1.0
echo Main-Class: com.truthlens.Main
echo.
) > "%~dp0manifest.txt"

"%JAR_CMD%" cfm "%~dp0TruthLens.jar" "%~dp0manifest.txt" -C "%~dp0bin" . 2>nul
if %ERRORLEVEL% NEQ 0 (
    "%JAR_CMD%" cfm "%~dp0TruthLens_app.jar" "%~dp0manifest.txt" -C "%~dp0bin" . 2>nul
    echo [NOTE] Bin compiled successfully. Note: If an old TruthLens window is open, please close it to update the JAR file.
)
del "%~dp0manifest.txt"

echo.
echo ===================================================
echo  Build Successful! Created: TruthLens.jar
echo ===================================================
echo Double click run.bat to launch the application.
pause
