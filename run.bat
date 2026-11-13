@echo off
setlocal
title TruthLens - Real vs AI & Fake News Forensic Detector

where java >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    set JAVA_CMD=java
) else if exist "C:\Program Files\Microsoft\jdk-21.0.13.21-hotspot\bin\java.exe" (
    set "JAVA_CMD=C:\Program Files\Microsoft\jdk-21.0.13.21-hotspot\bin\java.exe"
) else (
    echo [ERROR] Java could not be located. Please make sure Java 21 is installed.
    pause
    exit /b 1
)

echo Starting TruthLens Forensic Suite (Latest Engine)...
if exist "%~dp0bin\com\truthlens\Main.class" (
    start "" "%JAVA_CMD%" -cp "%~dp0bin" com.truthlens.Main
) else (
    start "" "%JAVA_CMD%" -jar "%~dp0TruthLens.jar"
)
exit /b 0
