# Database Schema Documentation

## Entity Relationship Diagram

```
┌─────────────────┐
│   CUSTOMERS     │
├─────────────────┤
│ id (PK)         │
│ name            │
│ phone           │
│ address         │
│ created_at      │
└────────┬────────┘
         │
         │ 1:N
         │
         ▼
┌─────────────────┐
│    VEHICLES     │
├─────────────────┤
│ id (PK)         │
│ customer_id (FK)│◄─────┐
│ car_model       │      │
│ plate_number    │      │
│ created_at      │      │
└────────┬────────┘      │
         │               │
         │ 1:N           │
         │               │
         ▼               │
┌─────────────────┐      │
│      JOBS       │      │
├─────────────────┤      │
│ id (PK)         │      │
│ vehicle_id (FK) │      │
│ assigned_worker │      │
│ issue           │      │
│ work_done       │      │
│ status          │      │
│ date            │      │
│ created_at      │      │
└────────┬────────┘      │
         │               │
         │ 1:1           │
         │               │
         ▼               │
┌─────────────────┐      │
│    INVOICES     │      │
├─────────────────┤      │
│ id (PK)         │      │
│ job_id (FK)     │      │
│ total_amount    │      │
│ payment_status  │      │
│ created_at      │      │
└─────────────────┘      │
                         │
                         │
┌─────────────────┐      │
│  APPOINTMENTS   │      │
├─────────────────┤      │
│ id (PK)         │      │
│ customer_id (FK)│──────┘
│ name            │
│ phone           │
│ car_model       │
│ problem         │
│ date            │
│ time            │
│ status          │
│ created_at      │
└─────────────────┘
```

## Table Details

### 1. CUSTOMERS

**Purpose**: Store customer information

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique customer identifier |
| name | TEXT | NOT NULL | Customer full name |
| phone | TEXT | NOT NULL | Contact phone number |
| address | TEXT | NOT NULL | Customer address |
| created_at | TIMESTAMP | DEFAULT NOW() | Record creation timestamp |

**Relationships**:
- One customer can have many vehicles (1:N)
- One customer can have many appointments (1:N)

**RLS Policies**:
- Owner & Receptionist: Full access (SELECT, INSERT, UPDATE, DELETE)

---

### 2. VEHICLES

**Purpose**: Track customer vehicles

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique vehicle identifier |
| customer_id | UUID | FOREIGN KEY → customers(id), NOT NULL | Owner of the vehicle |
| car_model | TEXT | NOT NULL | Vehicle make and model |
| plate_number | TEXT | NOT NULL | License plate number |
| created_at | TIMESTAMP | DEFAULT NOW() | Record creation timestamp |

**Relationships**:
- Many vehicles belong to one customer (N:1)
- One vehicle can have many jobs (1:N)

**RLS Policies**:
- Owner & Receptionist: Full access (SELECT, INSERT, UPDATE, DELETE)

**Cascade Rules**:
- ON DELETE CASCADE: When customer is deleted, all their vehicles are deleted

---

### 3. APPOINTMENTS

**Purpose**: Manage service appointment bookings

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique appointment identifier |
| customer_id | UUID | FOREIGN KEY → customers(id), NULLABLE | Customer who booked (optional) |
| name | TEXT | NOT NULL | Customer name |
| phone | TEXT | NOT NULL | Contact phone |
| car_model | TEXT | NOT NULL | Vehicle description |
| problem | TEXT | NOT NULL | Issue description |
| date | DATE | NOT NULL | Appointment date |
| time | TEXT | NOT NULL | Appointment time |
| status | TEXT | DEFAULT 'Pending', CHECK constraint | Appointment status |
| created_at | TIMESTAMP | DEFAULT NOW() | Record creation timestamp |

**Status Values**:
- `Pending` - Awaiting confirmation
- `Confirmed` - Confirmed by staff
- `Completed` - Service completed
- `Cancelled` - Appointment cancelled

**Relationships**:
- Many appointments can belong to one customer (N:1, optional)

**RLS Policies**:
- Staff (Owner, Receptionist, Worker): View all
- Customers: View own appointments only
- Anyone: Can create (for booking)
- Owner & Receptionist: Update and delete

**Cascade Rules**:
- ON DELETE SET NULL: When customer is deleted, appointment remains but customer_id is set to NULL

---

### 4. JOBS

**Purpose**: Track repair work orders

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique job identifier |
| vehicle_id | UUID | FOREIGN KEY → vehicles(id), NOT NULL | Vehicle being serviced |
| assigned_worker_id | UUID | FOREIGN KEY → auth.users(id), NULLABLE | Assigned mechanic |
| issue | TEXT | NOT NULL | Problem description |
| work_done | TEXT | NULLABLE | Work performed |
| status | TEXT | DEFAULT 'Pending', CHECK constraint | Job status |
| date | DATE | NOT NULL | Job date |
| created_at | TIMESTAMP | DEFAULT NOW() | Record creation timestamp |

**Status Values**:
- `Pending` - Not started
- `In Progress` - Currently being worked on
- `Completed` - Work finished

**Relationships**:
- Many jobs belong to one vehicle (N:1)
- One job has one invoice (1:1)
- Many jobs can be assigned to one worker (N:1)

**RLS Policies**:
- Owner & Receptionist: Full access
- Workers: View and update assigned jobs only

**Cascade Rules**:
- ON DELETE CASCADE: When vehicle is deleted, all its jobs are deleted
- ON DELETE SET NULL: When worker is deleted, jobs remain but assigned_worker_id is set to NULL

---

### 5. INVOICES

**Purpose**: Manage billing and payments

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique invoice identifier |
| job_id | UUID | FOREIGN KEY → jobs(id), NOT NULL | Associated job |
| total_amount | NUMERIC(10,2) | NOT NULL | Total bill amount |
| payment_status | TEXT | DEFAULT 'Unpaid', CHECK constraint | Payment status |
| created_at | TIMESTAMP | DEFAULT NOW() | Record creation timestamp |

**Payment Status Values**:
- `Paid` - Fully paid
- `Unpaid` - Not paid
- `Partial` - Partially paid

**Relationships**:
- One invoice belongs to one job (1:1)

**RLS Policies**:
- Owner & Receptionist: Full access (SELECT, INSERT, UPDATE, DELETE)

**Cascade Rules**:
- ON DELETE CASCADE: When job is deleted, its invoice is deleted

---

## Indexes

Performance indexes created on frequently queried columns:

```sql
-- Vehicles
CREATE INDEX idx_vehicles_customer_id ON vehicles(customer_id);

-- Appointments
CREATE INDEX idx_appointments_customer_id ON appointments(customer_id);
CREATE INDEX idx_appointments_date ON appointments(date);
CREATE INDEX idx_appointments_status ON appointments(status);

-- Jobs
CREATE INDEX idx_jobs_vehicle_id ON jobs(vehicle_id);
CREATE INDEX idx_jobs_assigned_worker_id ON jobs(assigned_worker_id);
CREATE INDEX idx_jobs_status ON jobs(status);

-- Invoices
CREATE INDEX idx_invoices_job_id ON invoices(job_id);
CREATE INDEX idx_invoices_payment_status ON invoices(payment_status);
```

---

## Data Flow Examples

### Example 1: Customer Books Appointment

```
1. Customer fills booking form
   ↓
2. INSERT INTO appointments (customer_id, name, phone, car_model, problem, date, time)
   ↓
3. Status = 'Pending'
   ↓
4. Receptionist reviews
   ↓
5. UPDATE appointments SET status = 'Confirmed'
```

### Example 2: Job Creation and Completion

```
1. Receptionist creates job from appointment
   ↓
2. INSERT INTO jobs (vehicle_id, issue, date)
   ↓
3. Assign to worker
   ↓
4. UPDATE jobs SET assigned_worker_id = worker_id
   ↓
5. Worker updates status
   ↓
6. UPDATE jobs SET status = 'In Progress', work_done = 'description'
   ↓
7. Worker completes job
   ↓
8. UPDATE jobs SET status = 'Completed'
   ↓
9. Receptionist creates invoice
   ↓
10. INSERT INTO invoices (job_id, total_amount)
```

### Example 3: Customer Lookup

```
1. Search for customer by name/phone
   ↓
2. SELECT * FROM customers WHERE name LIKE '%search%'
   ↓
3. Get customer's vehicles
   ↓
4. SELECT * FROM vehicles WHERE customer_id = customer_id
   ↓
5. Get vehicle's job history
   ↓
6. SELECT * FROM jobs WHERE vehicle_id = vehicle_id
   ↓
7. Get job invoices
   ↓
8. SELECT * FROM invoices WHERE job_id IN (job_ids)
```

---

## Row Level Security (RLS) Summary

### Access Matrix

| Table | Owner | Receptionist | Worker | Customer |
|-------|-------|--------------|--------|----------|
| customers | Full | Full | None | None |
| vehicles | Full | Full | None | None |
| appointments | Full | Full | View All | View Own |
| jobs | Full | Full | View/Update Assigned | None |
| invoices | Full | Full | None | None |

### Policy Implementation

RLS policies use JWT claims to determine user role:

```sql
-- Example policy
CREATE POLICY "policy_name"
  ON table_name FOR operation
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') = 'owner'
  );
```

**JWT Structure**:
```json
{
  "sub": "user-uuid",
  "user_metadata": {
    "role": "owner"
  }
}
```

---

## Sample Queries

### Get Customer with All Related Data

```sql
SELECT 
  c.id,
  c.name,
  c.phone,
  c.address,
  json_agg(DISTINCT v.*) as vehicles,
  json_agg(DISTINCT a.*) as appointments
FROM customers c
LEFT JOIN vehicles v ON v.customer_id = c.id
LEFT JOIN appointments a ON a.customer_id = c.id
WHERE c.id = 'customer-uuid'
GROUP BY c.id;
```

### Get Job with Invoice and Vehicle Info

```sql
SELECT 
  j.*,
  v.car_model,
  v.plate_number,
  c.name as customer_name,
  i.total_amount,
  i.payment_status
FROM jobs j
JOIN vehicles v ON v.id = j.vehicle_id
JOIN customers c ON c.id = v.customer_id
LEFT JOIN invoices i ON i.job_id = j.id
WHERE j.id = 'job-uuid';
```

### Get Worker's Assigned Jobs

```sql
SELECT 
  j.*,
  v.car_model,
  v.plate_number,
  c.name as customer_name
FROM jobs j
JOIN vehicles v ON v.id = j.vehicle_id
JOIN customers c ON c.id = v.customer_id
WHERE j.assigned_worker_id = 'worker-uuid'
  AND j.status != 'Completed'
ORDER BY j.date DESC;
```

### Revenue Report

```sql
SELECT 
  DATE_TRUNC('month', i.created_at) as month,
  COUNT(*) as invoice_count,
  SUM(i.total_amount) as total_revenue,
  SUM(CASE WHEN i.payment_status = 'Paid' THEN i.total_amount ELSE 0 END) as paid_revenue,
  SUM(CASE WHEN i.payment_status = 'Unpaid' THEN i.total_amount ELSE 0 END) as unpaid_revenue
FROM invoices i
GROUP BY DATE_TRUNC('month', i.created_at)
ORDER BY month DESC;
```

---

## Maintenance

### Backup

```bash
# Using Supabase CLI
supabase db dump -f backup.sql

# Restore
supabase db reset
psql -f backup.sql
```

### Cleanup Old Records

```sql
-- Delete old completed appointments (older than 1 year)
DELETE FROM appointments 
WHERE status = 'Completed' 
  AND created_at < NOW() - INTERVAL '1 year';

-- Archive old invoices
-- (Create archive table first)
INSERT INTO invoices_archive 
SELECT * FROM invoices 
WHERE created_at < NOW() - INTERVAL '2 years';
```

---

## Migration Strategy

When adding new features:

1. Create migration SQL file
2. Test in development
3. Backup production database
4. Apply migration
5. Verify data integrity
6. Update RLS policies if needed

---

**Database Version**: 1.0
**Last Updated**: 2024
**Maintained By**: Auto Repair CRM Team
