# Supabase Setup Guide - Complete Backend Configuration

## Overview

This guide walks you through setting up the complete Supabase backend for the Auto Repair CRM system, including database tables, relationships, RLS policies, and test users.

## Prerequisites

- Supabase account (free tier works)
- Access to Supabase Dashboard

## Step 1: Create Supabase Project

1. Go to [supabase.com](https://supabase.com)
2. Click "New Project"
3. Fill in:
   - **Name**: Auto Repair CRM
   - **Database Password**: (save this securely)
   - **Region**: Choose closest to your users
4. Click "Create new project"
5. Wait 2-3 minutes for provisioning

## Step 2: Execute SQL Setup Script

### Method 1: SQL Editor (Recommended)

1. In Supabase Dashboard, go to **SQL Editor** (left sidebar)
2. Click **New Query**
3. Open `supabase-setup.sql` from your project
4. Copy the ENTIRE contents
5. Paste into the SQL Editor
6. Click **Run** (or press Ctrl+Enter)
7. Wait for execution to complete

### Method 2: Via Supabase CLI

```bash
# Install Supabase CLI
npm install -g supabase

# Login
supabase login

# Link to your project
supabase link --project-ref your-project-ref

# Run migration
supabase db push
```

### Verify Setup

After running the script, you should see:
- ✅ 5 tables created
- ✅ RLS enabled on all tables
- ✅ Multiple policies per table
- ✅ Sample data inserted

Check the output at the bottom of the SQL execution for verification queries.

## Step 3: Configure Authentication

### Enable Email Provider

1. Go to **Authentication** → **Providers**
2. Find **Email** provider
3. Ensure it's **Enabled**
4. Configure settings:
   - ✅ Enable email provider
   - ⚠️ Disable "Confirm email" (for testing)
   - ⚠️ Disable "Secure email change" (for testing)

### Email Templates (Optional)

1. Go to **Authentication** → **Email Templates**
2. Customize confirmation and reset emails
3. Add your branding

## Step 4: Create Test Users

### Create Users via Dashboard

1. Go to **Authentication** → **Users**
2. Click **Add User** → **Create new user**
3. Create 4 test users:

#### User 1: Owner
- **Email**: owner@autorepair.com
- **Password**: owner123456
- **Auto Confirm User**: ✅ Yes
- Click **Create User**

#### User 2: Receptionist
- **Email**: receptionist@autorepair.com
- **Password**: receptionist123456
- **Auto Confirm User**: ✅ Yes
- Click **Create User**

#### User 3: Worker
- **Email**: worker@autorepair.com
- **Password**: worker123456
- **Auto Confirm User**: ✅ Yes
- Click **Create User**

#### User 4: Customer
- **Email**: customer@autorepair.com
- **Password**: customer123456
- **Auto Confirm User**: ✅ Yes
- Click **Create User**

## Step 5: Add Role Metadata to Users

This is the MOST IMPORTANT step! Without roles, users won't have proper access.

### For Each User:

1. Go to **Authentication** → **Users**
2. Click on the user's email
3. Scroll to **User Metadata** section
4. Click **Edit**
5. Add the role JSON:

#### Owner User Metadata:
```json
{
  "role": "owner"
}
```

#### Receptionist User Metadata:
```json
{
  "role": "receptionist"
}
```

#### Worker User Metadata:
```json
{
  "role": "worker"
}
```

#### Customer User Metadata:
```json
{
  "role": "customer"
}
```

6. Click **Save**
7. Repeat for all 4 users

### Verify Metadata

Run this query in SQL Editor to verify:

```sql
SELECT 
  email,
  raw_user_meta_data->>'role' as role
FROM auth.users
ORDER BY email;
```

You should see all 4 users with their roles.

## Step 6: Get API Credentials

1. Go to **Settings** → **API**
2. Copy these values:

### Project URL
```
https://xtivjbeuxajkeltlbjgt.supabase.co
```

### Anon/Public Key
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

3. Update your `.env` file:

```env
VITE_SUPABASE_URL=your_project_url_here
VITE_SUPABASE_ANON_KEY=your_anon_key_here
```

## Step 7: Test the Setup

### Test Database Tables

Run in SQL Editor:

```sql
-- Check all tables exist
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;

-- Check sample data
SELECT COUNT(*) as customer_count FROM customers;
SELECT COUNT(*) as vehicle_count FROM vehicles;
SELECT COUNT(*) as appointment_count FROM appointments;
SELECT COUNT(*) as job_count FROM jobs;
SELECT COUNT(*) as invoice_count FROM invoices;
```

### Test RLS Policies

```sql
-- Check RLS is enabled
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';

-- Count policies
SELECT tablename, COUNT(*) as policy_count
FROM pg_policies
WHERE schemaname = 'public'
GROUP BY tablename;
```

### Test Authentication

1. Open your application
2. Try logging in with each test user
3. Verify role-based access:
   - **Owner**: Should see all pages
   - **Receptionist**: Should see customers, vehicles, appointments, jobs, invoices
   - **Worker**: Should see only assigned jobs
   - **Customer**: Should see booking and appointments

## Database Schema Reference

### Tables Created

1. **customers**
   - id (uuid, primary key)
   - name (text)
   - phone (text)
   - address (text)
   - created_at (timestamp)

2. **vehicles**
   - id (uuid, primary key)
   - customer_id (uuid, foreign key → customers)
   - car_model (text)
   - plate_number (text)
   - created_at (timestamp)

3. **appointments**
   - id (uuid, primary key)
   - customer_id (uuid, foreign key → customers, nullable)
   - name (text)
   - phone (text)
   - car_model (text)
   - problem (text)
   - date (date)
   - time (text)
   - status (text: Pending, Confirmed, Completed, Cancelled)
   - created_at (timestamp)

4. **jobs**
   - id (uuid, primary key)
   - vehicle_id (uuid, foreign key → vehicles)
   - assigned_worker_id (uuid, foreign key → auth.users, nullable)
   - issue (text)
   - work_done (text)
   - status (text: Pending, In Progress, Completed)
   - date (date)
   - created_at (timestamp)

5. **invoices**
   - id (uuid, primary key)
   - job_id (uuid, foreign key → jobs)
   - total_amount (numeric)
   - payment_status (text: Paid, Unpaid, Partial)
   - created_at (timestamp)

### Relationships

```
customers (1) ──→ (N) vehicles
vehicles (1) ──→ (N) jobs
jobs (1) ──→ (1) invoices
customers (1) ──→ (N) appointments (optional)
```

### RLS Policies Summary

#### Customers Table
- Owner & Receptionist: Full access (SELECT, INSERT, UPDATE, DELETE)

#### Vehicles Table
- Owner & Receptionist: Full access (SELECT, INSERT, UPDATE, DELETE)

#### Appointments Table
- Staff (Owner, Receptionist, Worker): View all
- Customers: View own appointments
- Anyone: Can create (for booking)
- Owner & Receptionist: Update and delete

#### Jobs Table
- Owner & Receptionist: Full access
- Workers: View and update assigned jobs only

#### Invoices Table
- Owner & Receptionist: Full access (SELECT, INSERT, UPDATE, DELETE)

## Troubleshooting

### Issue: "relation does not exist"

**Solution**: SQL script wasn't executed properly
```sql
-- Re-run the entire supabase-setup.sql script
```

### Issue: "permission denied for table"

**Solution**: RLS policies not created or user has no role
```sql
-- Check if RLS is enabled
SELECT tablename, rowsecurity FROM pg_tables WHERE schemaname = 'public';

-- Check user metadata
SELECT email, raw_user_meta_data FROM auth.users;
```

### Issue: User can't see any data

**Solution**: Check user role metadata
1. Go to Authentication → Users
2. Click on user
3. Verify User Metadata has `{"role": "owner"}` or appropriate role
4. Save and refresh app

### Issue: "JWT expired"

**Solution**: User session expired
- Logout and login again
- Check token expiration settings in Authentication → Settings

### Issue: Can't create appointments

**Solution**: Check appointment policy
```sql
-- Verify policy exists
SELECT * FROM pg_policies WHERE tablename = 'appointments' AND policyname LIKE '%create%';
```

## Advanced Configuration

### Add Custom Roles

To add a new role (e.g., "manager"):

1. Update RLS policies to include new role
2. Add user with role metadata: `{"role": "manager"}`
3. Update frontend to handle new role

### Enable Realtime

For live updates:

1. Go to **Database** → **Replication**
2. Enable replication for tables
3. Update frontend to use Supabase Realtime

### Backup Database

```bash
# Using Supabase CLI
supabase db dump -f backup.sql

# Or via Dashboard
# Settings → Database → Backup
```

### Monitor Usage

1. Go to **Settings** → **Usage**
2. Monitor:
   - Database size
   - API requests
   - Bandwidth
   - Active users

## Security Best Practices

1. ✅ Always use RLS policies
2. ✅ Never expose service_role key in frontend
3. ✅ Use environment variables for credentials
4. ✅ Enable email confirmation in production
5. ✅ Set up proper CORS policies
6. ✅ Monitor authentication logs
7. ✅ Regularly backup database
8. ✅ Use strong passwords for users
9. ✅ Enable 2FA for admin accounts
10. ✅ Review and audit RLS policies regularly

## Next Steps

1. ✅ Database setup complete
2. ✅ Test users created
3. ✅ RLS policies active
4. → Test application with different roles
5. → Add real customer data
6. → Configure email templates
7. → Set up production environment
8. → Enable monitoring and alerts

## Support Resources

- [Supabase Documentation](https://supabase.com/docs)
- [RLS Guide](https://supabase.com/docs/guides/auth/row-level-security)
- [Authentication Guide](https://supabase.com/docs/guides/auth)
- [SQL Reference](https://supabase.com/docs/guides/database)

## Quick Reference Commands

```sql
-- View all tables
\dt

-- View table structure
\d customers

-- View all policies
SELECT * FROM pg_policies WHERE schemaname = 'public';

-- View all users
SELECT email, raw_user_meta_data FROM auth.users;

-- Test as specific user (in SQL Editor)
SET request.jwt.claims = '{"sub": "user-id-here", "user_metadata": {"role": "owner"}}';
SELECT * FROM customers;
```

---

**Setup Complete!** Your Supabase backend is now fully configured and ready to use with the Auto Repair CRM application.
