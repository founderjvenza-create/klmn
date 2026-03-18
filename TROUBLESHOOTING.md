# Troubleshooting Guide

Common issues and their solutions for the Auto Repair CRM application.

## Installation Issues

### npm install fails

**Problem**: Dependencies fail to install

**Solutions**:
```bash
# Clear npm cache
npm cache clean --force

# Delete node_modules and package-lock.json
rm -rf node_modules package-lock.json

# Reinstall
npm install
```

**Check Node version**:
```bash
node --version  # Should be 18 or higher
```

### Module not found errors

**Problem**: Import errors after installation

**Solution**:
```bash
# Restart dev server
# Press Ctrl+C to stop
npm run dev
```

## Authentication Issues

### Cannot sign up

**Problem**: Sign up fails with error

**Checklist**:
1. ✅ Supabase project is created
2. ✅ Email provider is enabled in Supabase Auth settings
3. ✅ Environment variables are correct in `.env`
4. ✅ SQL setup script has been run

**Solution**:
```bash
# Verify environment variables
cat .env

# Should show:
# VITE_SUPABASE_URL=https://xxxxx.supabase.co
# VITE_SUPABASE_ANON_KEY=eyJxxx...
```

### Cannot login

**Problem**: Login fails with "Invalid credentials"

**Solutions**:
1. Check email and password are correct
2. Verify user exists in Supabase Dashboard → Authentication → Users
3. Check if email confirmation is required (disable for testing)

**Disable email confirmation**:
1. Go to Supabase Dashboard
2. Authentication → Settings
3. Uncheck "Enable email confirmations"

### User has no role

**Problem**: User logs in but sees no menu items

**Solution**: Add role to user metadata
1. Go to Supabase Dashboard → Authentication → Users
2. Click on the user
3. Go to "User Metadata" section
4. Add:
```json
{
  "role": "owner"
}
```
5. Save and refresh the app

## Database Issues

### Tables not found

**Problem**: "relation does not exist" errors

**Solution**: Run the SQL setup script
1. Go to Supabase Dashboard → SQL Editor
2. Copy contents of `supabase-setup.sql`
3. Paste and click "Run"
4. Verify tables exist in Table Editor

### RLS policy errors

**Problem**: "permission denied" or "row level security" errors

**Solution**: Verify RLS policies are created
```sql
-- Check if RLS is enabled
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';

-- Should show rowsecurity = true for all tables
```

**Re-run RLS policies**:
1. Copy RLS policy section from `supabase-setup.sql`
2. Run in SQL Editor

### Cannot see data

**Problem**: Tables are empty or data doesn't show

**Checklist**:
1. ✅ User is logged in
2. ✅ User has correct role in metadata
3. ✅ RLS policies are created
4. ✅ Data exists in database

**Test RLS policies**:
```sql
-- Test as current user
SELECT * FROM customers;

-- If empty, check RLS policy
SELECT * FROM pg_policies WHERE tablename = 'customers';
```

## Development Issues

### Hot reload not working

**Problem**: Changes don't reflect in browser

**Solutions**:
```bash
# Restart dev server
# Press Ctrl+C
npm run dev

# Clear browser cache
# In browser: Ctrl+Shift+R (hard refresh)
```

### Port already in use

**Problem**: "Port 5173 is already in use"

**Solution**:
```bash
# Find and kill process on port 5173
# On Mac/Linux:
lsof -ti:5173 | xargs kill -9

# On Windows:
netstat -ano | findstr :5173
taskkill /PID <PID> /F

# Or use different port
npm run dev -- --port 3000
```

### Build fails

**Problem**: `npm run build` fails

**Solutions**:
```bash
# Check for TypeScript errors
npm run build 2>&1 | grep error

# Clear dist folder
rm -rf dist

# Rebuild
npm run build
```

## UI Issues

### Styles not loading

**Problem**: App looks unstyled

**Solutions**:
1. Check if Tailwind CSS is configured
2. Verify `index.css` imports Tailwind
3. Restart dev server

```bash
# Verify Tailwind config exists
ls tailwind.config.js

# Should exist and contain color configuration
```

### Modal not closing

**Problem**: Modal stays open after action

**Solution**: Check if `onClose` is called in component
```javascript
// Ensure modal has onClose handler
<Modal isOpen={isOpen} onClose={() => setIsOpen(false)}>
```

### Icons not showing

**Problem**: Lucide icons don't render

**Solution**:
```bash
# Reinstall lucide-react
npm uninstall lucide-react
npm install lucide-react
```

## Data Issues

### Foreign key constraint errors

**Problem**: Cannot create record due to foreign key

**Example**: Cannot create vehicle without customer

**Solution**: Create parent record first
1. Create customer first
2. Then create vehicle with customer_id

### Duplicate key errors

**Problem**: "duplicate key value violates unique constraint"

**Common causes**:
- Duplicate email in customers
- Duplicate license plate in vehicles

**Solution**: Use unique values or update existing record

### Cascade delete issues

**Problem**: Cannot delete customer with vehicles

**Note**: This should work automatically due to CASCADE

**If it doesn't work**:
```sql
-- Check foreign key constraints
SELECT
  tc.table_name, 
  kcu.column_name,
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name,
  rc.delete_rule
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
JOIN information_schema.referential_constraints AS rc
  ON rc.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY';
```

## Deployment Issues

### Vercel build fails

**Problem**: Build fails on Vercel

**Solutions**:
1. Check build logs in Vercel dashboard
2. Verify environment variables are set
3. Test build locally: `npm run build`

**Common causes**:
- Missing environment variables
- Import errors
- TypeScript errors

### Environment variables not working

**Problem**: App can't connect to Supabase in production

**Solution**: Add environment variables in Vercel
1. Go to Vercel project settings
2. Environment Variables section
3. Add:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
4. Redeploy

### 404 on page refresh

**Problem**: Direct URL access returns 404

**Solution**: Verify `vercel.json` exists with:
```json
{
  "rewrites": [{ "source": "/(.*)", "destination": "/" }]
}
```

## Performance Issues

### Slow page load

**Solutions**:
1. Check network tab in browser DevTools
2. Optimize images
3. Reduce bundle size
4. Enable caching

### Slow database queries

**Solutions**:
```sql
-- Add indexes for frequently queried columns
CREATE INDEX idx_vehicles_customer_id ON vehicles(customer_id);
CREATE INDEX idx_appointments_vehicle_id ON appointments(vehicle_id);
CREATE INDEX idx_job_cards_appointment_id ON job_cards(appointment_id);
```

## Browser Console Errors

### CORS errors

**Problem**: "CORS policy" errors

**Note**: Should not happen with Supabase

**If it does**:
1. Check Supabase URL is correct
2. Verify anon key is correct
3. Check Supabase project is active

### WebSocket errors

**Problem**: WebSocket connection errors

**Note**: These are warnings, not critical

**To fix**: Enable Realtime in Supabase if needed

### Hydration errors

**Problem**: React hydration mismatch

**Solution**: Ensure server and client render same content
```javascript
// Use useEffect for client-only code
useEffect(() => {
  // Client-only code here
}, [])
```

## Testing Issues

### Cannot create test data

**Problem**: Test data creation fails

**Solution**: Use correct role
1. Login as owner or reception
2. These roles have permission to create data

### Test users not working

**Problem**: Test users can't login

**Solution**: Verify user metadata
```sql
-- Check user metadata in Supabase
SELECT id, email, raw_user_meta_data 
FROM auth.users;

-- Should show role in raw_user_meta_data
```

## Getting Help

### Check Browser Console
1. Open DevTools (F12)
2. Go to Console tab
3. Look for error messages

### Check Network Tab
1. Open DevTools (F12)
2. Go to Network tab
3. Look for failed requests
4. Check request/response details

### Check Supabase Logs
1. Go to Supabase Dashboard
2. Logs section
3. Filter by error level

### Enable Debug Mode
```javascript
// In supabase.js, add:
const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    debug: true
  }
})
```

## Common Error Messages

### "Invalid API key"
- Check environment variables
- Verify Supabase anon key is correct

### "JWT expired"
- User session expired
- Logout and login again

### "Permission denied"
- Check user role
- Verify RLS policies

### "Network error"
- Check internet connection
- Verify Supabase project is active
- Check Supabase URL is correct

### "Unique constraint violation"
- Duplicate email or license plate
- Use unique values

## Still Having Issues?

1. **Check Documentation**:
   - README.md
   - DEPLOYMENT.md
   - FEATURES.md

2. **Review Code**:
   - Check browser console
   - Review Supabase logs
   - Test API calls in Supabase API docs

3. **Start Fresh**:
   ```bash
   # Clean install
   rm -rf node_modules package-lock.json
   npm install
   
   # Reset database (WARNING: deletes all data)
   # Drop all tables in Supabase SQL Editor
   # Re-run supabase-setup.sql
   ```

4. **Verify Setup**:
   - [ ] Node.js 18+ installed
   - [ ] Supabase project created
   - [ ] SQL script executed
   - [ ] Environment variables set
   - [ ] Dependencies installed
   - [ ] Dev server running

## Prevention Tips

1. Always commit working code
2. Test locally before deploying
3. Keep dependencies updated
4. Monitor Supabase usage
5. Backup database regularly
6. Use version control
7. Document custom changes
8. Test with different roles
9. Validate user input
10. Handle errors gracefully
