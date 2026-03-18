# Quick Start Guide

Get your Auto Repair CRM up and running in 5 minutes!

## 1. Install Dependencies (1 min)

```bash
npm install
```

## 2. Setup Supabase (2 min)

### Create Project
1. Go to [supabase.com](https://supabase.com) and create a new project
2. Wait for provisioning to complete

### Run SQL Setup
1. Go to **SQL Editor** in Supabase dashboard
2. Copy all content from `supabase-setup.sql`
3. Paste and click **Run**

### Get Credentials
1. Go to **Settings** → **API**
2. Copy **Project URL** and **anon public key**
3. Update `.env` file with your credentials

## 3. Configure Environment (30 sec)

Edit `.env` file:
```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here
```

## 4. Run the App (30 sec)

```bash
npm run dev
```

Open [http://localhost:5173](http://localhost:5173)

## 5. Create Your First User (1 min)

1. Click **Sign Up**
2. Enter email and password
3. Select role (start with "Owner" for full access)
4. Click **Sign Up**
5. Go back to **Sign In** and login

## You're Ready! 🎉

### What to do next:

1. **Add Customers**: Go to Customers page and add your first customer
2. **Add Vehicles**: Link vehicles to customers
3. **Create Appointments**: Schedule service appointments
4. **Manage Jobs**: Convert appointments to job cards
5. **Generate Invoices**: Create invoices for completed work

### Test Different Roles:

Create additional users with different roles to see how permissions work:
- **Owner**: Full access to everything
- **Reception**: Manage customers, vehicles, appointments, invoices
- **Worker**: View and update assigned jobs
- **Customer**: Book appointments and track status

## Need Help?

- Check `README.md` for detailed documentation
- See `DEPLOYMENT.md` for production deployment
- Review `supabase-setup.sql` for database schema

## Common Issues

**Can't login?**
- Make sure you ran the SQL setup script
- Check that email provider is enabled in Supabase Auth settings

**No data showing?**
- Verify you're logged in with the correct role
- Check browser console for errors
- Ensure RLS policies were created (they're in the SQL script)

**Build errors?**
- Delete `node_modules` and run `npm install` again
- Make sure you're using Node.js 18 or higher

---

Happy building! 🚗🔧
