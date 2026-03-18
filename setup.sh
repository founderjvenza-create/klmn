#!/bin/bash

# Auto Repair CRM - Automated Setup Script
# This script automates the initial setup process

echo "🚗 Auto Repair CRM - Setup Script"
echo "=================================="
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18+ first."
    exit 1
fi

echo "✅ Node.js found: $(node --version)"
echo ""

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm first."
    exit 1
fi

echo "✅ npm found: $(npm --version)"
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
npm install

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed successfully"
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "⚠️  .env file not found. Creating from .env.example..."
    cp .env.example .env
    echo "✅ .env file created"
    echo ""
    echo "⚠️  IMPORTANT: Edit .env file with your Supabase credentials!"
    echo ""
else
    echo "✅ .env file exists"
    echo ""
fi

# Display next steps
echo "=================================="
echo "✅ Setup Complete!"
echo "=================================="
echo ""
echo "📋 Next Steps:"
echo ""
echo "1. Setup Supabase Backend:"
echo "   - Go to https://supabase.com"
echo "   - Create a new project"
echo "   - Go to SQL Editor"
echo "   - Copy and paste contents of supabase-setup.sql"
echo "   - Click 'Run'"
echo ""
echo "2. Configure Environment:"
echo "   - Edit .env file"
echo "   - Add your Supabase URL and anon key"
echo "   - Get these from: Settings → API in Supabase"
echo ""
echo "3. Create Test Users:"
echo "   - See TEST_USERS.md for credentials"
echo "   - Create users in Supabase Dashboard"
echo "   - Add role to user metadata"
echo ""
echo "4. Run the Application:"
echo "   npm run dev"
echo ""
echo "5. Open Browser:"
echo "   http://localhost:5173"
echo ""
echo "📚 Documentation:"
echo "   - Quick Start: QUICKSTART.md"
echo "   - Backend Setup: SUPABASE_SETUP_GUIDE.md"
echo "   - Test Users: TEST_USERS.md"
echo ""
echo "🎉 Happy coding!"
