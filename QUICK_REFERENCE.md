# Quick Reference Card

One-page reference for the Auto Repair CRM system.

## 🔑 Test Login Credentials

```
Owner:        owner@autorepair.com / owner123456
Receptionist: receptionist@autorepair.com / receptionist123456
Worker:       worker@autorepair.com / worker123456
Customer:     customer@autorepair.com / customer123456
```

## 🎨 Color Scheme

```
Primary:    #dc6625 (Orange)
Secondary:  #487fc5 (Blue)
Background: #ffffff (White)
Text:       #000000 (Black)
```

## 📊 Database Tables

```
customers → vehicles → jobs → invoices
customers → appointments
```

## 🔐 Role Permissions

| Feature | Owner | Receptionist | Worker | Customer |
|---------|-------|--------------|--------|----------|
| Customers | ✅ | ✅ | ❌ | ❌ |
| Vehicles | ✅ | ✅ | ❌ | ❌ |
| Appointments | ✅ | ✅ | ✅ | Own Only |
| Jobs | ✅ | ✅ | Assigned | ❌ |
| Invoices | ✅ | ✅ | ❌ | ❌ |
| Booking | ❌ | ❌ | ❌ | ✅ |

## 🚀 Quick Commands

```bash
# Install
npm install

# Run dev
npm run dev

# Build
npm run build

# Preview
npm run preview
```

## 📁 Key Files

```
supabase-setup.sql       # Database setup (run in Supabase)
.env                     # Your credentials
src/lib/supabase.js      # Supabase client
src/contexts/AuthContext.jsx  # Authentication
```

## 🔄 Status Flows

**Appointments**: Pending → Confirmed → Completed
**Jobs**: Pending → In Progress → Completed  
**Invoices**: Unpaid → Paid

## 📖 Essential Docs

- **Setup**: QUICKSTART.md
- **Backend**: SUPABASE_SETUP_GUIDE.md
- **Deploy**: DEPLOYMENT.md
- **Help**: TROUBLESHOOTING.md

## 🌐 URLs

```
Local:      http://localhost:5173
Supabase:   https://xtivjbeuxajkeltlbjgt.supabase.co
```

## 🔧 Common Queries

### Get All Customers
```javascript
const { data } = await supabase
  .from('customers')
  .select('*')
```

### Create Appointment
```javascript
const { data } = await supabase
  .from('appointments')
  .insert([{ name, phone, car_model, problem, date, time }])
```

### Update Job Status
```javascript
const { data } = await supabase
  .from('jobs')
  .update({ status: 'Completed' })
  .eq('id', jobId)
```

## 🐛 Quick Fixes

**Can't login?**
→ Check user metadata has role

**No data showing?**
→ Verify RLS policies created

**Build fails?**
→ Delete node_modules, npm install

**404 on refresh?**
→ Check vercel.json exists

## 📞 Support

1. Check TROUBLESHOOTING.md
2. Review browser console
3. Check Supabase logs
4. Verify RLS policies

---

**Full Docs**: See DOCUMENTATION_INDEX.md
