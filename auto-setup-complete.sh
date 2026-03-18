#!/bin/bash

# ============================================
# Auto Repair CRM - Complete Automated Setup
# ============================================
# This script automates as much as possible

set -e  # Exit on error

echo "🚗 Auto Repair CRM - Complete Automated Setup"
echo "=============================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Step 1: Check Node.js
echo "🔍 Checking prerequisites..."
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is not installed${NC}"
    echo "   Install from: https://nodejs.org"
    exit 1
fi
echo -e "${GREEN}✅ Node.js found: $(node --version)${NC}"

if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✅ npm found: $(npm --version)${NC}"
echo ""

# Step 2: Install dependencies
echo "📦 Installing dependencies..."
npm install --silent
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Dependencies installed${NC}"
else
    echo -e "${RED}❌ Failed to install dependencies${NC}"
    exit 1
fi
echo ""

# Step 3: Setup .env
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cp .env.example .env
    echo -e "${GREEN}✅ .env file created${NC}"
    echo -e "${YELLOW}⚠️  You need to update .env with your Supabase credentials${NC}"
else
    echo -e "${GREEN}✅ .env file exists${NC}"
fi
echo ""

# Step 4: Display Supabase setup instructions
echo "=============================================="
echo -e "${BLUE}📊 SUPABASE BACKEND SETUP${NC}"
echo "=============================================="
echo ""
echo "Follow these steps to complete backend setup:"
echo ""
echo -e "${YELLOW}1️⃣ Create Supabase Project (3 minutes)${NC}"
echo "   → Go to: https://supabase.com"
echo "   → Click: 'New Project'"
echo "   → Name: Auto Repair CRM"
echo "   → Choose region and set password"
echo "   → Click: 'Create new project'"
echo "   → Wait for provisioning"
echo ""
echo -e "${YELLOW}2️⃣ Run SQL Setup (2 minutes)${NC}"
echo "   → In Supabase Dashboard: SQL Editor"
echo "   → Click: 'New Query'"
echo "   → Copy ENTIRE file: supabase-auto-setup.sql"
echo "   → Paste and click: 'Run'"
echo "   → Verify success messages appear"
echo ""
echo -e "${YELLOW}3️⃣ Create Test Users (3 minutes)${NC}"
echo "   → See: create-supabase-users.md"
echo "   → Or run: npm run create-users (requires service key)"
echo ""
echo -e "${YELLOW}4️⃣ Get API Credentials (1 minute)${NC}"
echo "   → In Supabase: Settings → API"
echo "   → Copy: Project URL"
echo "   → Copy: anon public key"
echo "   → Update: .env file"
echo ""
echo -e "${YELLOW}5️⃣ Verify Setup (1 minute)${NC}"
echo "   → Run: npm run verify"
echo ""
echo -e "${YELLOW}6️⃣ Launch Application (1 minute)${NC}"
echo "   → Run: npm run dev"
echo "   → Open: http://localhost:5173"
echo "   → Login: owner@autorepair.com / owner123456"
echo ""
echo "=============================================="
echo -e "${GREEN}✅ Local setup complete!${NC}"
echo "=============================================="
echo ""
echo "📚 Documentation:"
echo "   - Quick Start: QUICKSTART.md"
echo "   - Full Guide: COMPLETE_SETUP_GUIDE.md"
echo "   - User Creation: create-supabase-users.md"
echo "   - Test Users: TEST_USERS.md"
echo ""
echo "🎯 Next: Follow the Supabase setup steps above"
echo ""
