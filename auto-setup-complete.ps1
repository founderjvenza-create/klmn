# ============================================
# Auto Repair CRM - Complete Automated Setup
# ============================================
# PowerShell version for Windows

$ErrorActionPreference = "Stop"

Write-Host "🚗 Auto Repair CRM - Complete Automated Setup" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Node.js
Write-Host "🔍 Checking prerequisites..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js found: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js is not installed" -ForegroundColor Red
    Write-Host "   Install from: https://nodejs.org" -ForegroundColor Yellow
    exit 1
}

try {
    $npmVersion = npm --version
    Write-Host "✅ npm found: $npmVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ npm is not installed" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Step 2: Install dependencies
Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow
npm install --silent
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Dependencies installed" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Step 3: Setup .env
if (-not (Test-Path .env)) {
    Write-Host "📝 Creating .env file..." -ForegroundColor Yellow
    Copy-Item .env.example .env
    Write-Host "✅ .env file created" -ForegroundColor Green
    Write-Host "⚠️  You need to update .env with your Supabase credentials" -ForegroundColor Yellow
} else {
    Write-Host "✅ .env file exists" -ForegroundColor Green
}
Write-Host ""

# Step 4: Display Supabase setup instructions
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "📊 SUPABASE BACKEND SETUP" -ForegroundColor Blue
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Follow these steps to complete backend setup:" -ForegroundColor White
Write-Host ""
Write-Host "1️⃣ Create Supabase Project (3 minutes)" -ForegroundColor Yellow
Write-Host "   → Go to: https://supabase.com"
Write-Host "   → Click: 'New Project'"
Write-Host "   → Name: Auto Repair CRM"
Write-Host "   → Choose region and set password"
Write-Host "   → Click: 'Create new project'"
Write-Host "   → Wait for provisioning"
Write-Host ""
Write-Host "2️⃣ Run SQL Setup (2 minutes)" -ForegroundColor Yellow
Write-Host "   → In Supabase Dashboard: SQL Editor"
Write-Host "   → Click: 'New Query'"
Write-Host "   → Copy ENTIRE file: supabase-auto-setup.sql"
Write-Host "   → Paste and click: 'Run'"
Write-Host "   → Verify success messages appear"
Write-Host ""
Write-Host "3️⃣ Create Test Users (3 minutes)" -ForegroundColor Yellow
Write-Host "   → See: create-supabase-users.md"
Write-Host "   → Or run: npm run create-users (requires service key)"
Write-Host ""
Write-Host "4️⃣ Get API Credentials (1 minute)" -ForegroundColor Yellow
Write-Host "   → In Supabase: Settings → API"
Write-Host "   → Copy: Project URL"
Write-Host "   → Copy: anon public key"
Write-Host "   → Update: .env file"
Write-Host ""
Write-Host "5️⃣ Verify Setup (1 minute)" -ForegroundColor Yellow
Write-Host "   → Run: npm run verify"
Write-Host ""
Write-Host "6️⃣ Launch Application (1 minute)" -ForegroundColor Yellow
Write-Host "   → Run: npm run dev"
Write-Host "   → Open: http://localhost:5173"
Write-Host "   → Login: owner@autorepair.com / owner123456"
Write-Host ""
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "✅ Local setup complete!" -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📚 Documentation:" -ForegroundColor Cyan
Write-Host "   - Quick Start: QUICKSTART.md"
Write-Host "   - Full Guide: COMPLETE_SETUP_GUIDE.md"
Write-Host "   - User Creation: create-supabase-users.md"
Write-Host "   - Test Users: TEST_USERS.md"
Write-Host ""
Write-Host "🎯 Next: Follow the Supabase setup steps above" -ForegroundColor Green
Write-Host ""
