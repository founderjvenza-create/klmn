# API Reference - Supabase Queries

Complete reference for all database operations in the Auto Repair CRM.

## Authentication

### Sign Up
```javascript
const { data, error } = await supabase.auth.signUp({
  email: 'user@example.com',
  password: 'password123',
  options: {
    data: {
      role: 'customer' // owner, receptionist, worker, customer
    }
  }
})
```

### Sign In
```javascript
const { data, error } = await supabase.auth.signInWithPassword({
  email: 'user@example.com',
  password: 'password123'
})
```

### Sign Out
```javascript
const { error } = await supabase.auth.signOut()
```

### Get Current User
```javascript
const { data: { user } } = await supabase.auth.getUser()
const role = user?.user_metadata?.role
```

---

## Customers

### Get All Customers
```javascript
const { data, error } = await supabase
  .from('customers')
  .select('*')
  .order('created_at', { ascending: false })
```

### Get Customer by ID
```javascript
const { data, error } = await supabase
  .from('customers')
  .select('*')
  .eq('id', customerId)
  .single()
```

### Create Customer
```javascript
const { data, error } = await supabase
  .from('customers')
  .insert([{
    name: 'John Doe',
    phone: '555-0123',
    address: '123 Main St'
  }])
  .select()
```

### Update Customer
```javascript
const { data, error } = await supabase
  .from('customers')
  .update({
    name: 'John Smith',
    phone: '555-0124'
  })
  .eq('id', customerId)
```

### Delete Customer
```javascript
const { error } = await supabase
  .from('customers')
  .delete()
  .eq('id', customerId)
```

### Search Customers
```javascript
const { data, error } = await supabase
  .from('customers')
  .select('*')
  .or(`name.ilike.%${searchTerm}%,phone.ilike.%${searchTerm}%`)
```

---

## Vehicles

### Get All Vehicles with Customer Info
```javascript
const { data, error } = await supabase
  .from('vehicles')
  .select('*, customers(name, phone)')
  .order('created_at', { ascending: false })
```

### Get Vehicles by Customer
```javascript
const { data, error } = await supabase
  .from('vehicles')
  .select('*')
  .eq('customer_id', customerId)
```

### Create Vehicle
```javascript
const { data, error } = await supabase
  .from('vehicles')
  .insert([{
    customer_id: customerId,
    car_model: 'Toyota Camry 2020',
    plate_number: 'ABC-1234'
  }])
  .select()
```

### Update Vehicle
```javascript
const { data, error } = await supabase
  .from('vehicles')
  .update({
    car_model: 'Honda Accord 2021',
    plate_number: 'XYZ-5678'
  })
  .eq('id', vehicleId)
```

### Delete Vehicle
```javascript
const { error } = await supabase
  .from('vehicles')
  .delete()
  .eq('id', vehicleId)
```

---

## Appointments

### Get All Appointments with Relations
```javascript
const { data, error } = await supabase
  .from('appointments')
  .select(`
    *,
    customers(name, phone)
  `)
  .order('date', { ascending: false })
```

### Get Customer's Appointments
```javascript
const { data, error } = await supabase
  .from('appointments')
  .select('*')
  .eq('customer_id', customerId)
  .order('date', { ascending: false })
```

### Create Appointment (Customer Booking)
```javascript
const { data, error } = await supabase
  .from('appointments')
  .insert([{
    customer_id: customerId, // optional
    name: 'John Doe',
    phone: '555-0123',
    car_model: 'Toyota Camry',
    problem: 'Oil change needed',
    date: '2024-03-20',
    time: '10:00 AM',
    status: 'Pending'
  }])
  .select()
```

### Update Appointment Status
```javascript
const { data, error } = await supabase
  .from('appointments')
  .update({ status: 'Confirmed' })
  .eq('id', appointmentId)
```

### Filter by Status
```javascript
const { data, error } = await supabase
  .from('appointments')
  .select('*')
  .eq('status', 'Pending')
```

### Filter by Date Range
```javascript
const { data, error } = await supabase
  .from('appointments')
  .select('*')
  .gte('date', '2024-01-01')
  .lte('date', '2024-12-31')
```

---

## Jobs

### Get All Jobs with Relations
```javascript
const { data, error } = await supabase
  .from('jobs')
  .select(`
    *,
    vehicles(
      car_model,
      plate_number,
      customers(name, phone)
    )
  `)
  .order('created_at', { ascending: false })
```

### Get Worker's Assigned Jobs
```javascript
const { data, error } = await supabase
  .from('jobs')
  .select(`
    *,
    vehicles(
      car_model,
      plate_number,
      customers(name)
    )
  `)
  .eq('assigned_worker_id', workerId)
  .order('date', { ascending: false })
```

### Create Job
```javascript
const { data, error } = await supabase
  .from('jobs')
  .insert([{
    vehicle_id: vehicleId,
    assigned_worker_id: workerId, // optional
    issue: 'Engine diagnostic needed',
    status: 'Pending',
    date: '2024-03-20'
  }])
  .select()
```

### Update Job Status
```javascript
const { data, error } = await supabase
  .from('jobs')
  .update({
    status: 'In Progress',
    work_done: 'Replaced oil filter and changed oil'
  })
  .eq('id', jobId)
```

### Assign Job to Worker
```javascript
const { data, error } = await supabase
  .from('jobs')
  .update({ assigned_worker_id: workerId })
  .eq('id', jobId)
```

### Get Jobs by Status
```javascript
const { data, error } = await supabase
  .from('jobs')
  .select('*')
  .eq('status', 'Pending')
```

---

## Invoices

### Get All Invoices with Relations
```javascript
const { data, error } = await supabase
  .from('invoices')
  .select(`
    *,
    jobs(
      issue,
      work_done,
      vehicles(
        car_model,
        customers(name, phone)
      )
    )
  `)
  .order('created_at', { ascending: false })
```

### Create Invoice
```javascript
const { data, error } = await supabase
  .from('invoices')
  .insert([{
    job_id: jobId,
    total_amount: 250.00,
    payment_status: 'Unpaid'
  }])
  .select()
```

### Update Payment Status
```javascript
const { data, error } = await supabase
  .from('invoices')
  .update({ payment_status: 'Paid' })
  .eq('id', invoiceId)
```

### Get Unpaid Invoices
```javascript
const { data, error } = await supabase
  .from('invoices')
  .select('*')
  .eq('payment_status', 'Unpaid')
```

### Calculate Total Revenue
```javascript
const { data, error } = await supabase
  .from('invoices')
  .select('total_amount')

const totalRevenue = data?.reduce((sum, inv) => sum + parseFloat(inv.total_amount), 0) || 0
```

---

## Statistics & Analytics

### Dashboard Stats
```javascript
// Get counts for dashboard
const [customers, vehicles, appointments, jobs, invoices] = await Promise.all([
  supabase.from('customers').select('*', { count: 'exact', head: true }),
  supabase.from('vehicles').select('*', { count: 'exact', head: true }),
  supabase.from('appointments').select('*', { count: 'exact', head: true }),
  supabase.from('jobs').select('*', { count: 'exact', head: true }),
  supabase.from('invoices').select('total_amount')
])

const stats = {
  customers: customers.count,
  vehicles: vehicles.count,
  appointments: appointments.count,
  jobs: jobs.count,
  invoices: invoices.data?.length,
  revenue: invoices.data?.reduce((sum, inv) => sum + parseFloat(inv.total_amount), 0)
}
```

### Jobs by Status
```javascript
const { data, error } = await supabase
  .from('jobs')
  .select('status')

const statusCounts = data?.reduce((acc, job) => {
  acc[job.status] = (acc[job.status] || 0) + 1
  return acc
}, {})
```

### Revenue by Month
```javascript
const { data, error } = await supabase
  .from('invoices')
  .select('total_amount, created_at')
  .gte('created_at', '2024-01-01')
  .lte('created_at', '2024-12-31')

// Group by month in JavaScript
const monthlyRevenue = data?.reduce((acc, inv) => {
  const month = new Date(inv.created_at).toLocaleString('default', { month: 'long' })
  acc[month] = (acc[month] || 0) + parseFloat(inv.total_amount)
  return acc
}, {})
```

---

## Advanced Queries

### Get Customer Complete Profile
```javascript
const { data, error } = await supabase
  .from('customers')
  .select(`
    *,
    vehicles(
      *,
      jobs(
        *,
        invoices(*)
      )
    ),
    appointments(*)
  `)
  .eq('id', customerId)
  .single()
```

### Get Vehicle Service History
```javascript
const { data, error } = await supabase
  .from('vehicles')
  .select(`
    *,
    jobs(
      *,
      invoices(*)
    )
  `)
  .eq('id', vehicleId)
  .single()
```

### Get Pending Work Queue
```javascript
const { data, error } = await supabase
  .from('jobs')
  .select(`
    *,
    vehicles(
      car_model,
      plate_number,
      customers(name, phone)
    )
  `)
  .in('status', ['Pending', 'In Progress'])
  .order('date', { ascending: true })
```

### Get Overdue Appointments
```javascript
const { data, error } = await supabase
  .from('appointments')
  .select('*')
  .lt('date', new Date().toISOString().split('T')[0])
  .eq('status', 'Pending')
```

---

## Real-time Subscriptions

### Subscribe to New Appointments
```javascript
const subscription = supabase
  .channel('appointments')
  .on('postgres_changes', {
    event: 'INSERT',
    schema: 'public',
    table: 'appointments'
  }, (payload) => {
    console.log('New appointment:', payload.new)
    // Update UI
  })
  .subscribe()

// Cleanup
subscription.unsubscribe()
```

### Subscribe to Job Status Changes
```javascript
const subscription = supabase
  .channel('jobs')
  .on('postgres_changes', {
    event: 'UPDATE',
    schema: 'public',
    table: 'jobs',
    filter: `assigned_worker_id=eq.${workerId}`
  }, (payload) => {
    console.log('Job updated:', payload.new)
    // Update UI
  })
  .subscribe()
```

---

## Error Handling

### Standard Error Handling Pattern
```javascript
const { data, error } = await supabase
  .from('customers')
  .select('*')

if (error) {
  console.error('Error:', error.message)
  toast.error('Failed to load customers')
  return
}

// Use data
setCustomers(data)
```

### Handling Unique Constraint Violations
```javascript
const { data, error } = await supabase
  .from('vehicles')
  .insert([{ plate_number: 'ABC-123', ... }])

if (error) {
  if (error.code === '23505') { // Unique violation
    toast.error('License plate already exists')
  } else {
    toast.error('Error creating vehicle')
  }
}
```

### Handling Foreign Key Violations
```javascript
const { error } = await supabase
  .from('vehicles')
  .insert([{ customer_id: 'invalid-id', ... }])

if (error) {
  if (error.code === '23503') { // Foreign key violation
    toast.error('Customer not found')
  }
}
```

---

## Pagination

### Basic Pagination
```javascript
const pageSize = 10
const page = 0

const { data, error, count } = await supabase
  .from('customers')
  .select('*', { count: 'exact' })
  .range(page * pageSize, (page + 1) * pageSize - 1)
```

### Infinite Scroll
```javascript
const { data, error } = await supabase
  .from('appointments')
  .select('*')
  .order('date', { ascending: false })
  .limit(20)
  .range(offset, offset + 19)
```

---

## Filtering

### Multiple Conditions (AND)
```javascript
const { data, error } = await supabase
  .from('jobs')
  .select('*')
  .eq('status', 'Pending')
  .eq('assigned_worker_id', workerId)
```

### Multiple Conditions (OR)
```javascript
const { data, error } = await supabase
  .from('appointments')
  .select('*')
  .or('status.eq.Pending,status.eq.Confirmed')
```

### Text Search
```javascript
const { data, error } = await supabase
  .from('customers')
  .select('*')
  .ilike('name', `%${searchTerm}%`)
```

### Date Range
```javascript
const { data, error } = await supabase
  .from('appointments')
  .select('*')
  .gte('date', startDate)
  .lte('date', endDate)
```

---

## Aggregations

### Count Records
```javascript
const { count, error } = await supabase
  .from('customers')
  .select('*', { count: 'exact', head: true })
```

### Sum Total Amount
```javascript
const { data, error } = await supabase
  .from('invoices')
  .select('total_amount')

const total = data?.reduce((sum, inv) => sum + parseFloat(inv.total_amount), 0)
```

### Group By Status
```javascript
const { data, error } = await supabase
  .from('jobs')
  .select('status')

const grouped = data?.reduce((acc, job) => {
  acc[job.status] = (acc[job.status] || 0) + 1
  return acc
}, {})
```

---

## Joins

### Get Vehicle with Customer and Jobs
```javascript
const { data, error } = await supabase
  .from('vehicles')
  .select(`
    *,
    customers(name, phone, address),
    jobs(
      *,
      invoices(total_amount, payment_status)
    )
  `)
  .eq('id', vehicleId)
  .single()
```

### Get Job with Full Context
```javascript
const { data, error } = await supabase
  .from('jobs')
  .select(`
    *,
    vehicles(
      car_model,
      plate_number,
      customers(name, phone)
    ),
    invoices(total_amount, payment_status)
  `)
  .eq('id', jobId)
  .single()
```

---

## Batch Operations

### Insert Multiple Records
```javascript
const { data, error } = await supabase
  .from('customers')
  .insert([
    { name: 'Customer 1', phone: '555-0001', address: 'Address 1' },
    { name: 'Customer 2', phone: '555-0002', address: 'Address 2' },
    { name: 'Customer 3', phone: '555-0003', address: 'Address 3' }
  ])
  .select()
```

### Update Multiple Records
```javascript
const { data, error } = await supabase
  .from('appointments')
  .update({ status: 'Cancelled' })
  .lt('date', '2024-01-01')
```

### Delete Multiple Records
```javascript
const { error } = await supabase
  .from('appointments')
  .delete()
  .eq('status', 'Cancelled')
  .lt('created_at', '2023-01-01')
```

---

## Transactions

Supabase doesn't support transactions directly in the client library. Use RPC functions for complex operations:

### Create RPC Function
```sql
CREATE OR REPLACE FUNCTION create_job_with_invoice(
  p_vehicle_id UUID,
  p_issue TEXT,
  p_date DATE,
  p_total_amount NUMERIC
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
  v_job_id UUID;
  v_invoice_id UUID;
BEGIN
  -- Insert job
  INSERT INTO jobs (vehicle_id, issue, date, status)
  VALUES (p_vehicle_id, p_issue, p_date, 'Pending')
  RETURNING id INTO v_job_id;
  
  -- Insert invoice
  INSERT INTO invoices (job_id, total_amount, payment_status)
  VALUES (v_job_id, p_total_amount, 'Unpaid')
  RETURNING id INTO v_invoice_id;
  
  RETURN json_build_object(
    'job_id', v_job_id,
    'invoice_id', v_invoice_id
  );
END;
$$;
```

### Call RPC Function
```javascript
const { data, error } = await supabase
  .rpc('create_job_with_invoice', {
    p_vehicle_id: vehicleId,
    p_issue: 'Engine repair',
    p_date: '2024-03-20',
    p_total_amount: 500.00
  })
```

---

## File Uploads (Optional)

### Upload Job Photo
```javascript
const { data, error } = await supabase.storage
  .from('job-photos')
  .upload(`${jobId}/${fileName}`, file)

// Get public URL
const { data: { publicUrl } } = supabase.storage
  .from('job-photos')
  .getPublicUrl(`${jobId}/${fileName}`)
```

---

## Best Practices

### 1. Always Handle Errors
```javascript
const { data, error } = await supabase.from('customers').select('*')
if (error) {
  console.error('Error:', error)
  toast.error('Failed to load data')
  return
}
```

### 2. Use Select Specific Columns
```javascript
// Good - only get what you need
const { data } = await supabase
  .from('customers')
  .select('id, name, phone')

// Avoid - gets all columns
const { data } = await supabase
  .from('customers')
  .select('*')
```

### 3. Use Indexes for Filtering
```javascript
// Efficient - uses index
const { data } = await supabase
  .from('jobs')
  .select('*')
  .eq('status', 'Pending')

// Less efficient - no index
const { data } = await supabase
  .from('jobs')
  .select('*')
  .ilike('work_done', '%repair%')
```

### 4. Limit Results
```javascript
const { data } = await supabase
  .from('appointments')
  .select('*')
  .limit(100)
```

### 5. Use Single for One Record
```javascript
const { data, error } = await supabase
  .from('customers')
  .select('*')
  .eq('id', customerId)
  .single() // Returns object instead of array
```

---

## Common Patterns

### Load Data on Component Mount
```javascript
useEffect(() => {
  const loadData = async () => {
    const { data, error } = await supabase
      .from('customers')
      .select('*')
    
    if (!error) {
      setCustomers(data)
    }
  }
  
  loadData()
}, [])
```

### Search with Debounce
```javascript
useEffect(() => {
  const timer = setTimeout(async () => {
    if (searchTerm) {
      const { data } = await supabase
        .from('customers')
        .select('*')
        .ilike('name', `%${searchTerm}%`)
      
      setFilteredCustomers(data)
    }
  }, 300)
  
  return () => clearTimeout(timer)
}, [searchTerm])
```

### Optimistic Updates
```javascript
const handleUpdate = async (id, newData) => {
  // Update UI immediately
  setItems(items.map(item => 
    item.id === id ? { ...item, ...newData } : item
  ))
  
  // Update database
  const { error } = await supabase
    .from('table')
    .update(newData)
    .eq('id', id)
  
  // Revert on error
  if (error) {
    loadItems() // Reload from database
    toast.error('Update failed')
  }
}
```

---

## Testing Queries

### Test in Supabase SQL Editor

```sql
-- Test as owner
SET request.jwt.claims = '{"sub": "user-id", "user_metadata": {"role": "owner"}}';
SELECT * FROM customers;

-- Test as worker
SET request.jwt.claims = '{"sub": "worker-id", "user_metadata": {"role": "worker"}}';
SELECT * FROM jobs WHERE assigned_worker_id = 'worker-id';

-- Test as customer
SET request.jwt.claims = '{"sub": "customer-id", "user_metadata": {"role": "customer"}}';
SELECT * FROM appointments WHERE customer_id = 'customer-id';
```

---

## Performance Tips

1. **Use indexes** for frequently filtered columns
2. **Limit results** to avoid large payloads
3. **Select specific columns** instead of `*`
4. **Use pagination** for large datasets
5. **Cache results** when appropriate
6. **Batch operations** when possible
7. **Use RPC functions** for complex operations
8. **Monitor query performance** in Supabase Dashboard

---

## Security Reminders

- ✅ Never expose `service_role` key in frontend
- ✅ Always use `anon` key in client applications
- ✅ RLS policies protect data automatically
- ✅ Validate user input before inserting
- ✅ Use parameterized queries (Supabase does this automatically)
- ✅ Check user role before sensitive operations
- ✅ Log security events

---

**API Version**: 1.0
**Supabase JS Client**: v2.39.7+
