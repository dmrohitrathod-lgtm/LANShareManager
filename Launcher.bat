@echo off
setlocal EnableExtensions EnableDelayedExpansion
title LANShare Manager v1.0

:: ==========================================================
:: LANShare Manager
:: Version : 0.1
:: Author  : Mango Creatif
:: ==========================================================

cd /d "%~dp0"

:: ----------------------------
:: Admin Check
:: ----------------------------
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ==========================================
    echo      Administrator permission required
    echo ==========================================
    echo.
    powershell -NoProfile -Command ^
    "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: ----------------------------
:: PowerShell Check
:: ----------------------------
where powershell.exe >nul 2>&1

if errorlevel 1 (
    cls
    echo.
    echo PowerShell not found.
    pause
    exit /b
)

:: ----------------------------
:: Create Project Folder
:: ----------------------------
if not exist "Logs" mkdir "Logs"
if not exist "Config" mkdir "Config"
if not exist "Core" mkdir "Core"

:: ----------------------------
:: Create Config if Missing
:: ----------------------------
if not exist "Config\Config.json" (
(
echo {
echo     "Version":"0.1",
echo     "FirstRun":true,
echo     "LogEnabled":true
echo }
)>Config\Config.json
)

:: ----------------------------
:: Log
:: ----------------------------
echo ==================================================>>Logs\Launcher.log
echo %date% %time% Launcher Started>>Logs\Launcher.log

:: ----------------------------
:: Main PowerShell
:: ----------------------------
if not exist "Core\Main.ps1" (

    cls

    echo.
    echo ==========================================
    echo Main.ps1 not found.
    echo.
    echo Please verify installation.
    echo ==========================================
    echo.

    pause

    exit /b
)

:: ----------------------------
:: Execute
:: ----------------------------
powershell.exe ^
-NoLogo ^
-NoProfile ^
-ExecutionPolicy Bypass ^
-File "Core\Main.ps1"

set ERR=%errorlevel%

echo Exit Code : %ERR%>>Logs\Launcher.log

exit /b