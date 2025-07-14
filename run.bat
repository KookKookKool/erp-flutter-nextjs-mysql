@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:menu
cls

REM Green text for menu title and icons
set "ESC=\033"
set "GREEN=%ESC%[32m"
set "RESET=%ESC%[0m"

set "icon_all=🚀"
set "icon_backend=🟩"
set "icon_frontend_web=🌐"
set "icon_frontend_emu=📱"
set "icon_reset=🔄"
set "icon_close=❌"

echo.
echo  ===================================
echo   %icon_all% ERP FLUTTER NEXTJS MYSQL MENU 
echo  ===================================

echo  1. %icon_all%  Run All (Backend, Browser, Frontend Web, Emulator)
echo  2. %icon_backend%  Run Backend (npm run dev)
echo  3. %icon_frontend_web%  Run Frontend Web (flutter run -d chrome)
echo  4. %icon_frontend_emu%  Run Frontend Emulator (emulator-5554)
echo  5. %icon_reset%  Reset All Processes
echo  6. %icon_close%  Close All Processes

echo.
echo  0. Exit

echo.
set /p choice=  Select menu [0-6]: 

if "%choice%"=="1" goto run_all
if "%choice%"=="2" goto run_backend
if "%choice%"=="3" goto run_frontend_web
if "%choice%"=="4" goto run_frontend_emu
if "%choice%"=="5" goto reset_all
if "%choice%"=="6" goto close_all
if "%choice%"=="0" exit

goto menu

:run_all
REM Get local IPv4 address (เลือกเฉพาะ 192. หรือ 10.)
set MYIP=
for /f "tokens=2 delims=: " %%a in ('ipconfig ^| findstr /c:"IPv4 Address"') do (
    set TMPIP=%%a
    set TMPIP=!TMPIP: =!
    echo !TMPIP! | findstr /b "192. 10." >nul
    if !errorlevel! == 0 (
        set MYIP=!TMPIP!
        goto ip_found
    )
)
:ip_found
if "%MYIP%"=="" set MYIP=localhost
start cmd /k "cd /d d:\flutter\erp_fluter_nextjs_mysql\backend && npm run dev"
timeout /t 5 >nul
start "" "http://%MYIP%:3000"
start "" "http://%MYIP%:8080"
start "" "http://%MYIP%:3000/test-registration.html"
start cmd /k "cd /d d:\flutter\erp_fluter_nextjs_mysql\frontend && flutter run -d chrome --dart-define=DEV_API_URL=http://%MYIP%:3000/api"
start cmd /k "cd /d d:\flutter\erp_fluter_nextjs_mysql\frontend && flutter run -d emulator-5554 --dart-define=DEV_API_URL=http://%MYIP%:3000/api"
goto menu

:run_backend
start cmd /k "cd /d d:\flutter\erp_fluter_nextjs_mysql\backend && npm run dev"
start "" "http://localhost:3000"
start "" "http://localhost:8080"
start "" "http://localhost:3000/test-registration.html"
goto menu

:run_frontend_web
set MYIP=
for /f "tokens=2 delims=: " %%a in ('ipconfig ^| findstr /c:"IPv4 Address"') do (
    set TMPIP=%%a
    set TMPIP=!TMPIP: =!
    echo !TMPIP! | findstr /b "192. 10." >nul
    if !errorlevel! == 0 (
        set MYIP=!TMPIP!
        goto ip_found_web
    )
)
:ip_found_web
if "%MYIP%"=="" set MYIP=localhost
start cmd /k "cd /d d:\flutter\erp_fluter_nextjs_mysql\frontend && flutter run -d chrome --dart-define=DEV_API_URL=http://%MYIP%:3000/api"
goto menu

:run_frontend_emu
set MYIP=
for /f "tokens=2 delims=: " %%a in ('ipconfig ^| findstr /c:"IPv4 Address"') do (
    set TMPIP=%%a
    set TMPIP=!TMPIP: =!
    echo !TMPIP! | findstr /b "192. 10." >nul
    if !errorlevel! == 0 (
        set MYIP=!TMPIP!
        goto ip_found_emu
    )
)
:ip_found_emu
if "%MYIP%"=="" set MYIP=localhost
start cmd /k "cd /d d:\flutter\erp_fluter_nextjs_mysql\frontend && flutter run -d emulator-5554 --dart-define=DEV_API_URL=http://%MYIP%:3000/api"
goto menu

:reset_all
taskkill /im node.exe /f >nul 2>&1
taskkill /im chrome.exe /f >nul 2>&1
taskkill /im flutter.exe /f >nul 2>&1
taskkill /im adb.exe /f >nul 2>&1
echo Processes reset.
pause
goto menu

:close_all
taskkill /im node.exe /f >nul 2>&1
taskkill /im chrome.exe /f >nul 2>&1
taskkill /im flutter.exe /f >nul 2>&1
taskkill /im adb.exe /f >nul 2>&1
echo All processes closed.
pause
exit
