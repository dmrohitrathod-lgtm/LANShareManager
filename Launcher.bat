@echo off
setlocal EnableExtensions EnableDelayedExpansion
title LANShare Manager v1.0

:: ==========================================================
:: LANShare Manager
:: Version : 1.0
:: Target  : Windows 10
:: ==========================================================

cd /d "%~dp0"

:: ----------------------------------------------------------
:: Administrator Check
:: ----------------------------------------------------------

net session >nul 2>&1

if NOT "%errorlevel%"=="0" (

    echo.
    echo ================================================
    echo.
    echo   Restarting As Administrator...
    echo.
    echo ================================================
    echo.

    powershell -NoProfile -ExecutionPolicy Bypass ^
    -Command "Start-Process -FilePath '%~f0' -Verb RunAs"

    exit /b

)

:: ----------------------------------------------------------
:: Windows Check
:: ----------------------------------------------------------

ver | find "10." >nul

if errorlevel 1 (

    cls

    echo.
    echo ================================================
    echo.
    echo This Utility Supports Windows 10 Only.
    echo.
    echo ================================================
    echo.

    pause

    exit

)

:: ----------------------------------------------------------
:: PowerShell Check
:: ----------------------------------------------------------

where powershell.exe >nul 2>&1

if errorlevel 1 (

    cls

    echo.
    echo Windows PowerShell Not Found.
    echo.

    pause

    exit

)

:: ----------------------------------------------------------
:: Create Folders
:: ----------------------------------------------------------

if not exist "Logs" mkdir Logs

if not exist "Config" mkdir Config

:: ----------------------------------------------------------
:: Create Config File
:: ----------------------------------------------------------

if not exist "Config\Config.json" (

(
echo {
echo     "Version":"1.0",
echo     "Mode":"Official",
echo     "Logging":true
echo }
)>Config\Config.json

)

:: ----------------------------------------------------------
:: Log
:: ----------------------------------------------------------

echo ======================================================>>Logs\LANShare.log
echo %date% %time% Launcher Started>>Logs\LANShare.log

:: ----------------------------------------------------------
:: Check Main Script
:: ----------------------------------------------------------

if not exist "LANShareManager.ps1" (

    cls

    echo.
    echo ================================================
    echo.
    echo LANShareManager.ps1 Not Found
    echo.
    echo ================================================
    echo.

    pause

    exit

)

:: ----------------------------------------------------------
:: Start PowerShell
:: ----------------------------------------------------------

powershell.exe ^
-NoLogo ^
-NoProfile ^
-ExecutionPolicy Bypass ^
-File "%~dp0LANShareManager.ps1"

set EXITCODE=%errorlevel%

echo Exit Code : %EXITCODE%>>Logs\LANShare.log

exit
