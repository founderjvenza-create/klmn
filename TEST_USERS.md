# Test Users Reference

Quick reference for testing the Auto Repair CRM with different user roles.

## Test User Credentials

### 👑 Owner Account
```
Email: owner@autorepair.com
Password: owner123456
Role: owner
```

**Access Level**: Full system access
- ✅ Dashboard with all statistics
- ✅ Customer management
- ✅ Vehicle management
- ✅ Appointment management
- ✅ Job management
- ✅ Invoice management
- ✅ View all data
- ✅ Full CRUD operations

---

### 📋 Receptionist Account
```
Email: receptionist@autorepair.com
Password: receptionist123456
Role: receptionist
```

**Access Level**: Customer-facing operations
- ✅ Dashboard with relevant stats
- ✅ Customer management (CRUD)
- ✅ Vehicle management (CRUD)
- ✅ Appointment management (CRUD)
- ✅ Job management (CRUD)
- ✅ Invoice management (CRUD)
- ❌ Cannot see worker-specific views

---

### 🔧 Worker Account
```
Email: worker@autorepair.com
Password: worker123456
Role: worker
```

**Access Level**: Job execution only
- ✅ Dashboard with job statistics
- ✅ View assigned jobs
- ✅ Update job status
- ✅ Add work notes
- ❌ Cannot see customers
- ❌ Cannot see vehicles
- ❌ Cannot create jobs
- ❌ Cannot see invoices

---

### 👤 Customer Account
```
Email: customer@autorepair.com
Password: customer123456
Role: customer
```

**Access Level**: Self-service booking
- ✅ Dashboard with quick actions
- ✅ Book appointments
- ✅ View own appointments
- ✅ Track appointment status
- ❌ Cannot see other customers
- ❌ Cannot see jobs
- ❌ Cannot see invoices

---

## How to Create These Users

### Option 1: Via Supabase Dashboard

1. Go to **Authentication** → **Users**
2. Click **Add User** → **Create new user**
3. Enter email and password
4. Check **Auto Confirm User**
5. Click **Create User**
6. Click on the created user
7. Scroll to **User Metadata**
8. Click **Edit** and add:
   ```json
   {
     "role": "owner"
   }
   ```
9. Click **Save**
10. Repeat for all 4 users

### Option 2: Via Application Signup

1. Go to `/signup` in your application
2. Enter email and password
3. Select role from dropdown
4. Click **Sign Up**
5. Verify email (if confirmation enabled)
6. Login

---

## Testing Scenarios

### Scenario 1: Customer Books Appointment

1. Login as **customer@autorepair.com**
2. Go to "Book Service"
3. Select vehicle (if none, contact receptionist)
4. Choose service type
5. Select date and time
6. Submit booking
7. View in "Appointments" page

### Scenario 2: Receptionist Manages Booking

1. Login as **receptionist@autorepair.com**
2. Go to "Appointments"
3. See pending appointment from customer
4. Update status to "Confirmed"
5. Go to "Jobs"
6. Create job from appointment
7. Assign to worker

### Scenario 3: Worker Completes Job

1. Login as **worker@autorepair.com**
2. Go to "Jobs" (see only assigned jobs)
3. Update status to "In Progress"
4. Add work notes
5. Update status to "Completed"

### Scenario 4: Receptionist Creates Invoice

1. Login as **receptionist@autorepair.com**
2. Go to "Invoices"
3. Create invoice from completed job
4. Enter total amount
5. Mark as "Paid" when customer pays

### Scenario 5: Owner Reviews Analytics

1. Login as **owner@autorepair.com**
2. View dashboard statistics
3. See total revenue
4. Review all customers
5. Check job completion rates
6. Monitor payment status

---

## Role Comparison Matrix

| Feature | Owner | Receptionist | Worker | Customer |
|---------|-------|--------------|--------|----------|
| View Dashboard | ✅ | ✅ | ✅ | ✅ |
| Manage Customers | ✅ | ✅ | ❌ | ❌ |
| Manage Vehicles | ✅ | ✅ | ❌ | ❌ |
| View All Appointments | ✅ | ✅ | ✅ | ❌ |
| View Own Appointments | N/A | N/A | N/A | ✅ |
| Create Appointments | ✅ | ✅ | ❌ | ✅ |
| Manage Jobs | ✅ | ✅ | ❌ | ❌ |
| View Assigned Jobs | N/A | N/A | ✅ | ❌ |
| Update Job Status | ✅ | ✅ | ✅* | ❌ |
| Manage Invoices | ✅ | ✅ | ❌ | ❌ |
| View Revenue | ✅ | ❌ | ❌ | ❌ |

*Workers can only update their assigned jobs

---

## User Metadata Format

When creating users, add this to User Metadata:

### Owner
```json
{
  "role": "owner"
}
```

### Receptionist
```json
{
  "role": "receptionist"
}
```

### Worker
```json
{
  "role": "worker"
}
```

### Customer
```json
{
  "role": "customer"
}
```

---

## Troubleshooting

### User can't login
- ✅ Check email and password are correct
- ✅ Verify user exists in Supabase Dashboard
- ✅ Check if email confirmation is required

### User has no menu items
- ✅ Check User Metadata has role field
- ✅ Verify role spelling is correct (lowercase)
- ✅ Logout and login again

### User sees wrong pages
- ✅ Verify role in User Metadata
- ✅ Check RLS policies are active
- ✅ Clear browser cache

### Worker can't see jobs
- ✅ Verify jobs are assigned to this worker
- ✅ Check assigned_worker_id matches user ID
- ✅ Verify RLS policy for workers

### Customer can't book
- ✅ Check if customer has vehicles
- ✅ Verify appointment creation policy
- ✅ Check form validation

---

## Adding More Test Users

To add more test users:

1. **Via Dashboard**: Follow Option 1 above
2. **Via Application**: Use signup page
3. **Via SQL**:
   ```sql
   -- This creates user in auth.users
   -- Then add metadata via Dashboard
   ```

---

## Security Notes

⚠️ **Important**: These are TEST credentials only!

- Change passwords in production
- Use strong passwords
- Enable email confirmation
- Enable 2FA for admin accounts
- Never commit credentials to git
- Use environment variables

---

## Quick Login Links

For development convenience:

```
Owner: http://localhost:5173/login
Receptionist: http://localhost:5173/login
Worker: http://localhost:5173/login
Customer: http://localhost:5173/login
```

All use the same login page, role is determined by user metadata.

---

## Sample Data Included

The SQL setup script includes:

- ✅ 4 sample customers
- ✅ 4 sample vehicles
- ✅ 3 sample appointments
- ✅ 2 sample jobs
- ✅ 1 sample invoice

This data is visible to Owner and Receptionist roles.

---

**Happy Testing!** 🚗🔧
