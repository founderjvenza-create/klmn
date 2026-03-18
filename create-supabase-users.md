# Automated User Creation Guide

Since Supabase doesn't allow user creation via SQL (security restriction), here are the FASTEST methods to create test users.

## 🚀 Method 1: Via Supabase Dashboard (5 minutes)

### Quick Steps:
1. Go to **Authentication** → **Users**
2. Click **Add User** → **Create new user**
3. For each user below:
   - Enter email and password
   - Check **Auto Confirm User** ✅
   - Click **Create User**
   - Click on the user
   - Click **Edit** in User Metadata section
   - Paste the JSON metadata
   - Click **Save**

### Users to Create:

#### 1️⃣ Owner
```
Email: owner@autorepair.com
Password: owner123456
Auto Confirm: ✅ Yes

User Metadata (click Edit and paste):
{"role": "owner"}
```

#### 2️⃣ Receptionist
```
Email: receptionist@autorepair.com
Password: receptionist123456
Auto Confirm: ✅ Yes

User Metadata (click Edit and paste):
{"role": "receptionist"}
```

#### 3️⃣ Worker
```
Email: worker@autorepair.com
Password: worker123456
Auto Confirm: ✅ Yes

User Metadata (click Edit and paste):
{"role": "worker"}
```

#### 4️⃣ Customer
```
Email: customer@autorepair.com
Password: customer123456
Auto Confirm: ✅ Yes

User Metadata (click Edit and paste):
{"role": "customer"}
```

---

## 🤖 Method 2: Via Supabase Management API (Automated)

Create a Node.js script to automate user creation:

### Create `create-users.js`:

```javascript
import { createClient } from '@supabase/supabase-js'

// Use SERVICE ROLE key (keep this secret!)
const supabaseUrl = 'YOUR_SUPABASE_URL'
const supabaseServiceKey = 'YOUR_SERVICE_ROLE_KEY' // From Settings → API

const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
})

const users = [
  { email: 'owner@autorepair.com', password: 'owner123456', role: 'owner' },
  { email: 'receptionist@autorepair.com', password: 'receptionist123456', role: 'receptionist' },
  { email: 'worker@autorepair.com', password: 'worker123456', role: 'worker' },
  { email: 'customer@autorepair.com', password: 'customer123456', role: 'customer' }
]

async function createUsers() {
  console.log('🚀 Creating test users...\n')

  for (const user of users) {
    const { data, error } = await supabase.auth.admin.createUser({
      email: user.email,
      password: user.password,
      email_confirm: true,
      user_metadata: {
        role: user.role
      }
    })

    if (error) {
      console.log(`❌ Error creating ${user.role}:`, error.message)
    } else {
      console.log(`✅ Created ${user.role}: ${user.email}`)
    }
  }

  console.log('\n🎉 User creation complete!')
  console.log('\n📋 Login Credentials:')
  users.forEach(u => {
    console.log(`\n${u.role.toUpperCase()}:`)
    console.log(`  Email: ${u.email}`)
    console.log(`  Password: ${u.password}`)
  })
}

createUsers()
```

### Run the script:
```bash
node create-users.js
```

---

## 🔧 Method 3: Via Application Signup (Manual but Easy)

1. Run your application: `npm run dev`
2. Go to `/signup`
3. Create each user:
   - Enter email and password
   - Select role from dropdown
   - Click Sign Up
4. Repeat for all 4 roles

---

## ⚡ Method 4: One-Click User Creation (Recommended)

### Create `setup-users.sh`:

```bash
#!/bin/bash

# Auto Repair CRM - Automated User Creation
# Requires: curl, jq

SUPABASE_URL="YOUR_SUPABASE_URL"
SERVICE_KEY="YOUR_SERVICE_ROLE_KEY"

echo "🚀 Creating test users..."
echo ""

# Function to create user
create_user() {
  local email=$1
  local password=$2
  local role=$3
  
  response=$(curl -s -X POST \
    "${SUPABASE_URL}/auth/v1/admin/users" \
    -H "apikey: ${SERVICE_KEY}" \
    -H "Authorization: Bearer ${SERVICE_KEY}" \
    -H "Content-Type: application/json" \
    -d "{
      \"email\": \"${email}\",
      \"password\": \"${password}\",
      \"email_confirm\": true,
      \"user_metadata\": {
        \"role\": \"${role}\"
      }
    }")
  
  if echo "$response" | jq -e '.id' > /dev/null 2>&1; then
    echo "✅ Created ${role}: ${email}"
  else
    echo "❌ Error creating ${role}: ${email}"
    echo "$response" | jq '.'
  fi
}

# Create all users
create_user "owner@autorepair.com" "owner123456" "owner"
create_user "receptionist@autorepair.com" "receptionist123456" "receptionist"
create_user "worker@autorepair.com" "worker123456" "worker"
create_user "customer@autorepair.com" "customer123456" "customer"

echo ""
echo "🎉 User creation complete!"
echo ""
echo "📋 Login Credentials:"
echo ""
echo "OWNER:"
echo "  Email: owner@autorepair.com"
echo "  Password: owner123456"
echo ""
echo "RECEPTIONIST:"
echo "  Email: receptionist@autorepair.com"
echo "  Password: receptionist123456"
echo ""
echo "WORKER:"
echo "  Email: worker@autorepair.com"
echo "  Password: worker123456"
echo ""
echo "CUSTOMER:"
echo "  Email: customer@autorepair.com"
echo "  Password: customer123456"
```

### Make executable and run:
```bash
chmod +x setup-users.sh
./setup-users.sh
```

---

## 🎯 Recommended Approach

**For fastest setup, use Method 1 (Dashboard):**
1. Takes only 5 minutes
2. No additional tools needed
3. Visual interface
4. Immediate verification

**For automation, use Method 2 or 4:**
1. Requires service role key
2. Can be scripted
3. Repeatable
4. Good for multiple environments

---

## ✅ Verification

After creating users, verify in SQL Editor:

```sql
-- Check all users exist with roles
SELECT 
  email,
  raw_user_meta_data->>'role' as role,
  created_at
FROM auth.users
ORDER BY email;
```

Expected output:
```
customer@autorepair.com     | customer      | 2024-03-18
owner@autorepair.com        | owner         | 2024-03-18
receptionist@autorepair.com | receptionist  | 2024-03-18
worker@autorepair.com       | worker        | 2024-03-18
```

---

## 🔒 Security Notes

### Service Role Key
- **NEVER** commit service role key to git
- **NEVER** expose in frontend code
- **ONLY** use for admin operations
- **KEEP** secure and private

### Test Passwords
- These are for TESTING only
- Change in production
- Use strong passwords
- Enable 2FA for admin accounts

---

## 🎊 After User Creation

1. ✅ Users created
2. ✅ Roles assigned
3. → Test login with each role
4. → Verify permissions work
5. → Start using the app!

---

**User Creation Guide Version**: 1.0
**Last Updated**: March 2024
