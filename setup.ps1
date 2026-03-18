# Auto Repair CRM - Automated Setup Script (PowerShell)
# This script automates the initial setup process

Write-Host "🚗 Auto Repair CRM - Setup Script" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Check if Node.js is installed
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js found: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js is not installed. Please install Node.js 18+ first." -ForegroundColor Red
    exit 1
}

Write-Host ""

# Check if npm is installed
try {
    $npmVersion = npm --version
    Write-Host "✅ npm found: $npmVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ npm is not installed. Please install npm first." -ForegroundColor Red
    exit 1
}

Write-Host ""

# Install dependencies
Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow
npm install

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Dependencies installed successfully" -ForegroundColor Green
Write-Host ""

# Check if .env file exists
if (-not (Test-Path .env)) {
    Write-Host "⚠️  .env file not found. Creating from .env.example..." -ForegroundColor Yellow
    Copy-Item .env.example .env
    Write-Host "✅ .env file created" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  IMPORTANT: Edit .env file with your Supabase credentials!" -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host "✅ .env file exists" -ForegroundColor Green
    Write-Host ""
}

# Display next steps
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "✅ Setup Complete!" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 Next Steps:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Setup Supabase Backend:"
Write-Host "   - Go to https://supabase.com"
Write-Host "   - Create a new project"
Write-Host "   - Go to SQL Editor"
Write-Host "   - Copy and paste contents of supabase-setup.sql"
Write-Host "   - Click 'Run'"
Write-Host ""
Write-Host "2. Configure Environment:"
Write-Host "   - Edit .env file"
Write-Host "   - Add your Supabase URL and anon key"
Write-Host "   - Get these from: Settings → API in Supabase"
Write-Host ""
Write-Host "3. Create Test Users:"
Write-Host "   - See TEST_USERS.md for credentials"
Write-Host "   - Create users in Supabase Dashboard"
Write-Host "   - Add role to user metadata"
Write-Host ""
Write-Host "4. Run the Application:"
Write-Host "   npm run dev" -ForegroundColor Yellow
Write-Host ""
Write-Host "5. Open Browser:"
Write-Host "   http://localhost:5173" -ForegroundColor Cyan
Write-Host ""
Write-Host "📚 Documentation:" -ForegroundColor Cyan
Write-Host "   - Quick Start: QUICKSTART.md"
Write-Host "   - Backend Setup: SUPABASE_SETUP_GUIDE.md"
Write-Host "   - Test Users: TEST_USERS.md"
Write-Host ""
Write-Host "🎉 Happy coding!" -ForegroundColor Green
