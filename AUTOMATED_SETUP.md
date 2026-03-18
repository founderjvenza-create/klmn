# 🤖 Automated Supabase Setup Guide

Complete automation guide for setting up the Auto Repair CRM backend with minimal manual intervention.

---

## 🎯 Goal

Set up the complete Supabase backend automatically with:
- ✅ All database tables
- ✅ Foreign key relationships
- ✅ Row Level Security policies
- ✅ Performance indexes
- ✅ Sample data
- ✅ Test users (semi-automated)

---

## ⚡ Quick Setup (10 Minutes Total)

### Step 1: Create Supabase Project (3 minutes)
1. Go to [supabase.com](https://supabase.com)
2. Click "New Project"
3. Enter project name: "Auto Repair CRM"
4. Choose region
5. Set database password (save it!)
6. Click "Create new project"
7. Wait for provisioning (~2 minutes)

### Step 2: Run Automated SQL Setup (2 minutes)
1. In Supabase Dashboard, go to **SQL Editor**
2. Click **New Query**
3. Copy **entire** contents of `supabase-auto-setup.sql`
4. Paste into editor
5. Click **Run** (or Ctrl+Enter)
6. Watch the success messages in the output

**✅ Database is now fully configured!**

### Step 3: Create Test Users (3 minutes)

#### Option A: Via Dashboard (Recommended - 3 minutes)
Follow the instructions displayed in the SQL output, or see [create-supabase-users.md](create-supabase-users.md)

#### Option B: Via Automation Script (2 minutes)
```bash
# Get your service_role key from Supabase Dashboard → Settings → API
SUPABASE_URL=your_url SERVICE_KEY=your_service_key npm run create-users
```

### Step 4: Get Credentials (1 minute)
1. Go to **Settings** → **API**
2. Copy **Project URL**
3. Copy **anon public key**
4. Update `.env` file

### Step 5: Verify Setup (1 minute)
```bash
npm run verify
```

**✅ If verification passes, you're ready to go!**

---

## 🚀 One-Command Setup (Advanced)

Create a master setup script:

### `auto-setup.sh` (Mac/Linux)
```bash
#!/bin/bash

echo "🚗 Auto Repair CRM - Automated Setup"
echo "===================================="
echo ""

# Step 1: Install dependencies
echo "📦 Installing dependencies..."
npm install
echo "✅ Dependencies installed"
echo ""

# Step 2: Check environment
if [ ! -f .env ]; then
  echo "⚠️  Creating .env from template..."
  cp .env.example .env
  echo "✅ .env created"
  echo ""
  echo "⚠️  IMPORTANT: Edit .env with your Supabase credentials!"
  echo ""
fi

# Step 3: Instructions
echo "📋 Next Steps:"
echo ""
echo "1. Create Supabase project at https://supabase.com"
echo ""
echo "2. Run SQL setup:"
echo "   - Go to SQL Editor in Supabase"
echo "   - Copy contents of: supabase-auto-setup.sql"
echo "   - Paste and click 'Run'"
echo ""
echo "3. Create users (choose one):"
echo "   A) Via Dashboard (5 min) - see create-supabase-users.md"
echo "   B) Via script (2 min):"
echo "      SUPABASE_URL=your_url SERVICE_KEY=your_key npm run create-users"
echo ""
echo "4. Update .env with your Supabase credentials"
echo ""
echo "5. Verify setup:"
echo "   npm run verify"
echo ""
echo "6. Run application:"
echo "   npm run dev"
echo ""
echo "📚 Full guide: QUICKSTART.md"
echo ""
```

### Make executable and run:
```bash
chmod +x auto-setup.sh
./auto-setup.sh
```

---

## 📊 What Gets Automated

### ✅ Fully Automated (No Manual Steps)
- Database table creation
- Foreign key relationships
- Indexes for performance
- RLS policy creation
- Sample data insertion
- Verification queries

### ⚠️ Semi-Automated (Minimal Manual Steps)
- Supabase project creation (1 click)
- SQL script execution (copy/paste/run)
- User creation (Dashboard or script)
- Environment variable setup (copy/paste)

### ❌ Cannot Be Automated (Supabase Limitations)
- Initial Supabase account creation
- Project provisioning
- Service role key retrieval

---

## 🔧 Automation Scripts Included

### 1. `supabase-auto-setup.sql`
**Purpose**: Complete database setup
**What it does**:
- Drops existing tables (clean slate)
- Creates all 5 tables
- Sets up foreign keys with CASCADE
- Creates performance indexes
- Enables RLS on all tables
- Creates 20+ RLS policies
- Inserts sample data
- Runs verification queries
- Displays setup summary

**How to use**:
```sql
-- Copy entire file and paste in Supabase SQL Editor
-- Click "Run"
-- Watch for success messages
```

### 2. `create-users.js`
**Purpose**: Automated user creation
**What it does**:
- Creates 4 test users
- Sets passwords
- Adds role metadata
- Confirms emails automatically

**How to use**:
```bash
SUPABASE_URL=your_url SERVICE_KEY=your_service_key npm run create-users
```

### 3. `verify-setup.js`
**Purpose**: Verify backend is ready
**What it does**:
- Checks .env file exists
- Verifies credentials
- Tests database connection
- Checks all tables exist
- Counts records
- Verifies authentication

**How to use**:
```bash
npm run verify
```

### 4. `setup.sh` / `setup.ps1`
**Purpose**: Initial project setup
**What it does**:
- Installs npm dependencies
- Creates .env from template
- Displays next steps

**How to use**:
```bash
./setup.sh        # Mac/Linux
.\setup.ps1       # Windows
```

---

## 🎯 Complete Automation Workflow

### Ideal Workflow (10 minutes)

```bash
# 1. Clone/download project
cd auto-repair-crm

# 2. Run initial setup
./setup.sh

# 3. Create Supabase project (manual - 3 min)
# Go to supabase.com and create project

# 4. Run SQL setup (manual - 1 min)
# Copy supabase-auto-setup.sql to SQL Editor and run

# 5. Create users (automated - 1 min)
SUPABASE_URL=your_url SERVICE_KEY=your_key npm run create-users

# 6. Update .env (manual - 1 min)
# Add your Supabase URL and anon key

# 7. Verify setup (automated - 30 sec)
npm run verify

# 8. Run application (automated - 30 sec)
npm run dev

# ✅ Done! Open http://localhost:5173
```

---

## 🔑 Getting Service Role Key

**For automated user creation, you need the service_role key:**

1. Go to Supabase Dashboard
2. Navigate to **Settings** → **API**
3. Scroll to **Project API keys**
4. Find **service_role** key (not anon key!)
5. Click **Reveal** and copy

**⚠️ SECURITY WARNING:**
- NEVER commit service_role key to git
- NEVER expose in frontend code
- ONLY use for admin operations
- KEEP secret and secure

---

## 📋 Verification Checklist

After running automated setup, verify:

### Database
```bash
npm run verify
```

Should show:
- ✅ customers: 5 records
- ✅ vehicles: 5 records
- ✅ appointments: 4 records
- ✅ jobs: 3 records
- ✅ invoices: 2 records

### Users (in Supabase Dashboard)
Go to **Authentication** → **Users**

Should see:
- ✅ owner@autorepair.com
- ✅ receptionist@autorepair.com
- ✅ worker@autorepair.com
- ✅ customer@autorepair.com

### RLS Policies (in SQL Editor)
```sql
SELECT tablename, COUNT(*) as policy_count
FROM pg_policies
WHERE schemaname = 'public'
GROUP BY tablename
ORDER BY tablename;
```

Should show:
- customers: 4 policies
- vehicles: 4 policies
- appointments: 5 policies
- jobs: 6 policies
- invoices: 4 policies

---

## 🎨 Customization

### Change Sample Data

Edit `supabase-auto-setup.sql` section:
```sql
-- STEP 6: INSERT SAMPLE DATA
-- Modify the INSERT statements to add your own data
```

### Add More Users

Edit `create-users.js`:
```javascript
const users = [
  // Add more users here
  { email: 'manager@autorepair.com', password: 'manager123', role: 'owner' }
]
```

### Modify RLS Policies

Edit `supabase-auto-setup.sql` section:
```sql
-- STEP 5: CREATE RLS POLICIES
-- Modify or add policies as needed
```

---

## 🔄 Reset and Retry

If something goes wrong:

### Reset Database
```sql
-- Run in Supabase SQL Editor
DROP TABLE IF EXISTS invoices CASCADE;
DROP TABLE IF EXISTS jobs CASCADE;
DROP TABLE IF EXISTS appointments CASCADE;
DROP TABLE IF EXISTS vehicles CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

-- Then re-run supabase-auto-setup.sql
```

### Delete Users
1. Go to **Authentication** → **Users**
2. Select users to delete
3. Click **Delete user**
4. Re-run user creation

### Start Fresh
```bash
# 1. Delete all tables (SQL above)
# 2. Delete all users (Dashboard)
# 3. Re-run supabase-auto-setup.sql
# 4. Re-run create-users.js
# 5. Verify with: npm run verify
```

---

## 🎯 Troubleshooting Automation

### Issue: SQL script fails

**Solution**:
- Check you copied the ENTIRE file
- Verify no syntax errors
- Run in a fresh Supabase project
- Check Supabase project is active

### Issue: User creation fails

**Solution**:
- Verify service_role key is correct
- Check users don't already exist
- Ensure email provider is enabled
- Try creating via Dashboard instead

### Issue: Verification fails

**Solution**:
```bash
# Check .env file
cat .env

# Should show:
# VITE_SUPABASE_URL=https://xxxxx.supabase.co
# VITE_SUPABASE_ANON_KEY=eyJxxx...

# If missing, add your credentials
```

### Issue: Can't login

**Solution**:
- Verify users were created
- Check user metadata has role
- Try password reset
- Check email confirmation is disabled (for testing)

---

## 💡 Pro Tips

1. **Use fresh Supabase project** for cleanest setup
2. **Copy entire SQL file** - don't miss any lines
3. **Wait for SQL to complete** - takes 10-30 seconds
4. **Check output messages** - they tell you what happened
5. **Run verify script** - confirms everything works
6. **Keep service_role key secret** - never commit to git

---

## 🎊 Success Indicators

After automated setup, you should see:

### In SQL Editor Output:
```
✅ Tables created: 5 out of 5
✅ RLS enabled on: 5 out of 5 tables
✅ RLS policies created: 23
✅ Sample data inserted:
   - Customers: 5
   - Vehicles: 5
   - Appointments: 4
   - Jobs: 3
   - Invoices: 2
```

### In Terminal (npm run verify):
```
✅ Table 'customers': 5 records
✅ Table 'vehicles': 5 records
✅ Table 'appointments': 4 records
✅ Table 'jobs': 3 records
✅ Table 'invoices': 2 records
✅ Authentication: Working
🎉 Setup verification PASSED!
```

### In Application:
- Login works with test credentials
- Dashboard shows statistics
- All pages load correctly
- Data displays properly
- Role-based access works

---

## 📚 Related Documentation

- **Quick Setup**: [QUICKSTART.md](QUICKSTART.md)
- **Manual Setup**: [SUPABASE_SETUP_GUIDE.md](SUPABASE_SETUP_GUIDE.md)
- **User Guide**: [create-supabase-users.md](create-supabase-users.md)
- **Test Credentials**: [TEST_USERS.md](TEST_USERS.md)
- **Troubleshooting**: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

## 🚀 You're Ready!

With these automation tools, your Supabase backend setup is:
- ✅ Fast (10 minutes total)
- ✅ Reliable (tested scripts)
- ✅ Repeatable (run multiple times)
- ✅ Verifiable (built-in checks)
- ✅ Complete (everything included)

**Next: Run `npm run dev` and start using your CRM!**

---

**Automation Version**: 1.0
**Last Updated**: March 2024
