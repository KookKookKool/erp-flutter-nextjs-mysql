@echo off
echo ======================================
echo   ERP System Setup Script
echo ======================================
echo.

echo 📁 Setting up Backend...
cd backend

echo 📝 Creating .env file from example...
if not exist .env (
    copy .env.example .env
    echo ✅ .env file created
) else (
    echo ℹ️  .env file already exists
)

echo 📦 Installing backend dependencies...
call npm install

echo 🐳 Starting database with Docker...
call docker-compose up -d

echo ⏳ Waiting for database to be ready...
timeout /t 10 /nobreak > nul

echo 🗄️  Setting up database schema...
call npx prisma db push

echo 🌱 Seeding database with sample data...
call npm run db:seed

echo 🚀 Starting backend server...
start cmd /k "npm run dev"

echo.
cd ..\frontend

echo 📱 Setting up Frontend...
echo 📦 Installing frontend dependencies...
call flutter pub get

echo 🔧 Generating localization files...
call flutter gen-l10n

echo.
echo ======================================
echo   Setup Complete!
echo ======================================
echo.
echo Backend is running at: http://localhost:3000
echo.
echo To start the Flutter app:
echo   1. Open a new terminal
echo   2. Navigate to frontend folder
echo   3. Run: flutter run
echo.
echo Admin Panel: http://localhost:3000/admin/login
echo   Email: admin@sunerp.com
echo   Password: admin123
echo.
echo Test Organizations:
echo   DEMO001 - บริษัท เดโม หนึ่ง จำกัด (APPROVED)
echo   DEMO002 - หจก. เดโม สอง (APPROVED)
echo   EXPIRED001 - บริษัท หมดอายุ จำกัด (EXPIRED)
echo.
pause
