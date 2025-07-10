@echo off
chcp 65001 > nul
title ERP Backend Management

:main
cls
echo =======================================
echo     🚀 ERP Backend Management Tool
echo =======================================
echo.
echo Select an option:
echo.
echo 1. 🏗️  Full Setup (First time installation)
echo 2. 🐳 Start Docker only  
echo 3. 🖥️  Start Development Server
echo 4. 🧪 Run Integration Tests
echo 5. 📊 Open Admin Dashboard
echo 6. 🗄️  Open phpMyAdmin
echo 7. 🔄 Reset Database
echo 8. 🛑 Stop All Services
echo 9. ❌ Exit
echo.
set /p choice="Enter your choice (1-9): "

if "%choice%"=="1" goto setup
if "%choice%"=="2" goto docker_start
if "%choice%"=="3" goto dev_start
if "%choice%"=="4" goto test
if "%choice%"=="5" goto admin_panel
if "%choice%"=="6" goto phpmyadmin
if "%choice%"=="7" goto reset_db
if "%choice%"=="8" goto stop_services
if "%choice%"=="9" goto exit
echo Invalid choice! Please try again.
timeout /t 2 > nul
goto main

:setup
cls
echo =======================================
echo     🏗️ Full Setup (First Time)
echo =======================================
echo.

echo 1. Installing dependencies...
call npm install
if errorlevel 1 (
    echo ❌ Failed to install dependencies
    pause
    goto main
)
echo ✅ Dependencies installed

echo.
echo 2. Starting Docker containers...
call docker-compose up -d
if errorlevel 1 (
    echo ❌ Failed to start Docker containers
    echo Please make sure Docker is running
    pause
    goto main
)
echo ✅ Docker containers started

echo.
echo 3. Waiting for database (30 seconds)...
timeout /t 30 /nobreak > nul

echo.
echo 4. Generating Prisma client...
call npx prisma generate
if errorlevel 1 (
    echo ❌ Failed to generate Prisma client
    pause
    goto main
)
echo ✅ Prisma client generated

echo.
echo 5. Pushing database schema...
call npx prisma db push --accept-data-loss
if errorlevel 1 (
    echo ❌ Failed to push database schema
    pause
    goto main
)
echo ✅ Database schema created

echo.
echo 6. Seeding initial data...
call npm run db:seed
if errorlevel 1 (
    echo ❌ Failed to seed database
    pause
    goto main
)
echo ✅ Database seeded

echo.
echo 🎉 Setup completed successfully!
echo.
echo Available services:
echo   🖥️  Backend: http://localhost:3000
echo   🔧 Admin Panel: http://localhost:3000/admin/login  
echo   🗄️  phpMyAdmin: http://localhost:8080
echo.
echo Admin credentials:
echo   📧 Email: admin@sunerp.com
echo   🔐 Password: admin123
echo.
pause
goto main

:docker_start
cls
echo =======================================
echo        🐳 Starting Docker Only
echo =======================================
echo.
call docker-compose up -d
if errorlevel 1 (
    echo ❌ Failed to start Docker containers
    pause
    goto main
)
echo ✅ Docker containers started successfully
echo.
echo Services:
echo   🗄️  MySQL: localhost:3306
echo   🖥️  phpMyAdmin: http://localhost:8080
echo.
pause
goto main

:dev_start
cls
echo =======================================
echo      🖥️ Starting Development Server
echo =======================================
echo.

echo Generating Prisma client...
call npx prisma generate > nul 2>&1

echo Starting development server...
echo.
echo 📍 Server will be available at:
echo   🖥️  Frontend: http://localhost:3000
echo   🔧 Admin Panel: http://localhost:3000/admin/login
echo   🧪 Test Registration: http://localhost:3000/test-registration.html
echo.
echo 🔑 Admin credentials:
echo   📧 Email: admin@sunerp.com  
echo   🔐 Password: admin123
echo.
echo Press Ctrl+C to stop the server
echo.
call npm run dev
pause
goto main

:test
cls
echo =======================================
echo        🧪 Running Integration Tests
echo =======================================
echo.
call npm run test:integration
echo.
pause
goto main

:admin_panel
echo Opening Admin Panel...
start "" "http://localhost:3000/admin/login"
echo.
echo 🔑 Admin credentials:
echo   📧 Email: admin@sunerp.com
echo   🔐 Password: admin123
echo.
pause
goto main

:phpmyadmin
echo Opening phpMyAdmin...
start "" "http://localhost:8080"
echo.
echo 🔑 Database credentials:
echo   🖥️  Server: mysql
echo   👤 Username: erp_app
echo   🔐 Password: erp_app_pass123
echo.
pause
goto main

:reset_db
cls
echo =======================================
echo        🔄 Resetting Database
echo =======================================
echo.
echo ⚠️  WARNING: This will delete all data!
set /p confirm="Are you sure? (y/N): "
if /i not "%confirm%"=="y" goto main

echo Resetting database schema...
call npx prisma db push --force-reset --accept-data-loss
if errorlevel 1 (
    echo ❌ Failed to reset database
    pause
    goto main
)

echo Re-seeding initial data...
call npm run db:seed
if errorlevel 1 (
    echo ❌ Failed to seed database
    pause
    goto main
)

echo ✅ Database reset completed
pause
goto main

:stop_services
cls
echo =======================================
echo        🛑 Stopping All Services
echo =======================================
echo.
echo Stopping Docker containers...
call docker-compose down
echo ✅ All services stopped
pause
goto main

:exit
echo.
echo 👋 Goodbye!
echo.
exit /b 0
