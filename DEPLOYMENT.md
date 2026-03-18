# Deployment Guide

## Prerequisites

- Node.js 18+ installed
- Supabase account
- Vercel account (for deployment)

## Step-by-Step Deployment

### 1. Supabase Setup

#### Create a New Project
1. Go to [supabase.com](https://supabase.com)
2. Click "New Project"
3. Fill in project details
4. Wait for project to be provisioned

#### Setup Database
1. In your Supabase dashboard, go to **SQL Editor**
2. Click "New Query"
3. Copy the entire contents of `supabase-setup.sql`
4. Paste and click "Run"
5. Verify all tables are created in **Table Editor**

#### Get API Credentials
1. Go to **Settings** → **API**
2. Copy your **Project URL** (e.g., `https://xxxxx.supabase.co`)
3. Copy your **anon/public key**

#### Configure Authentication
1. Go to **Authentication** → **Providers**
2. Enable **Email** provider
3. Disable email confirmation (optional for testing):
   - Go to **Authentication** → **Settings**
   - Disable "Enable email confirmations"

### 2. Local Development

#### Clone and Install
```bash
# Install dependencies
npm install
```

#### Configure Environment
Create `.env` file:
```env
VITE_SUPABASE_URL=your_project_url
VITE_SUPABASE_ANON_KEY=your_anon_key
```

#### Run Development Server
```bash
npm run dev
```

Visit `http://localhost:5173` to test locally.

### 3. Create Test Users

#### Option A: Via Signup Page
1. Go to `/signup`
2. Create users with different roles:
   - owner@test.com (role: owner)
   - reception@test.com (role: reception)
   - worker@test.com (role: worker)
   - customer@test.com (role: customer)

#### Option B: Via Supabase Dashboard
1. Go to **Authentication** → **Users**
2. Click "Add User"
3. Enter email and password
4. After creation, click on the user
5. Go to "User Metadata" tab
6. Add metadata:
```json
{
  "role": "owner"
}
```

### 4. Deploy to Vercel

#### Connect Repository
1. Push your code to GitHub:
```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin your-repo-url
git push -u origin main
```

2. Go to [vercel.com](https://vercel.com)
3. Click "New Project"
4. Import your GitHub repository

#### Configure Environment Variables
In Vercel project settings, add:
- `VITE_SUPABASE_URL` = your Supabase project URL
- `VITE_SUPABASE_ANON_KEY` = your Supabase anon key

#### Deploy
1. Click "Deploy"
2. Wait for build to complete
3. Visit your deployed URL

### 5. Post-Deployment

#### Test All Roles
1. Login with each role
2. Verify permissions:
   - Owner: Can access all pages
   - Reception: Can manage customers, vehicles, appointments, invoices
   - Worker: Can view and update assigned job cards
   - Customer: Can book appointments and view status

#### Add Sample Data
1. Login as reception/owner
2. Add customers
3. Add vehicles for customers
4. Create appointments
5. Convert appointments to job cards
6. Generate invoices

## Troubleshooting

### Authentication Issues
- Verify Supabase URL and key are correct
- Check if email provider is enabled
- Ensure user metadata includes role field

### RLS Policy Errors
- Verify all RLS policies are created
- Check user role in metadata matches policy requirements
- Test with Supabase SQL editor using `auth.uid()`

### Build Errors
- Clear node_modules and reinstall: `rm -rf node_modules && npm install`
- Check Node.js version: `node --version` (should be 18+)
- Verify all dependencies are installed

### Data Not Showing
- Check browser console for errors
- Verify RLS policies allow user to read data
- Test queries directly in Supabase SQL editor

## Production Checklist

- [ ] All environment variables configured
- [ ] Database tables created
- [ ] RLS policies enabled and tested
- [ ] Email authentication configured
- [ ] Test users created for each role
- [ ] Sample data added
- [ ] All pages tested on mobile and desktop
- [ ] Error handling verified
- [ ] Performance optimized

## Security Notes

1. **Never commit `.env` file** - It's in `.gitignore`
2. **Use environment variables** for all sensitive data
3. **RLS policies** protect data at database level
4. **Role-based access** enforced in both frontend and backend
5. **Supabase anon key** is safe to expose (RLS protects data)

## Maintenance

### Updating the App
```bash
git pull origin main
npm install
npm run build
```

### Database Migrations
When adding new features:
1. Write SQL migration scripts
2. Test in development Supabase project
3. Apply to production via SQL Editor
4. Update RLS policies if needed

### Monitoring
- Check Vercel Analytics for performance
- Monitor Supabase Dashboard for:
  - Database usage
  - API requests
  - Authentication activity
  - Error logs

## Support

For issues:
1. Check browser console for errors
2. Review Supabase logs
3. Verify RLS policies
4. Test API calls in Supabase API docs

## Next Steps

Consider adding:
- Email notifications for appointments
- SMS reminders
- Payment gateway integration
- Advanced reporting and analytics
- File uploads for job photos
- Real-time updates with Supabase Realtime
