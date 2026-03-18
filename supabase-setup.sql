-- ============================================
-- AUTO REPAIR CRM - COMPLETE SUPABASE SETUP
-- ============================================
-- This script creates all tables, relationships, RLS policies, and example users
-- Execute this entire script in Supabase SQL Editor

-- ============================================
-- STEP 1: DROP EXISTING TABLES (if any)
-- ============================================
DROP TABLE IF EXISTS invoices CASCADE;
DROP TABLE IF EXISTS jobs CASCADE;
DROP TABLE IF EXISTS appointments CASCADE;
DROP TABLE IF EXISTS vehicles CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

-- ============================================
-- STEP 2: CREATE TABLES
-- ============================================

-- Create customers table
CREATE TABLE customers (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  address TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create vehicles table
CREATE TABLE vehicles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  car_model TEXT NOT NULL,
  plate_number TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create appointments table
CREATE TABLE appointments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  customer_id UUID REFERENCES customers(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  car_model TEXT NOT NULL,
  problem TEXT NOT NULL,
  date DATE NOT NULL,
  time TEXT NOT NULL,
  status TEXT DEFAULT 'Pending' CHECK (status IN ('Pending', 'Confirmed', 'Completed', 'Cancelled')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create jobs table
CREATE TABLE jobs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  vehicle_id UUID NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
  assigned_worker_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  issue TEXT NOT NULL,
  work_done TEXT,
  status TEXT DEFAULT 'Pending' CHECK (status IN ('Pending', 'In Progress', 'Completed')),
  date DATE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create invoices table
CREATE TABLE invoices (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  total_amount NUMERIC(10, 2) NOT NULL,
  payment_status TEXT DEFAULT 'Unpaid' CHECK (payment_status IN ('Paid', 'Unpaid', 'Partial')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- STEP 3: CREATE INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX idx_vehicles_customer_id ON vehicles(customer_id);
CREATE INDEX idx_appointments_customer_id ON appointments(customer_id);
CREATE INDEX idx_appointments_date ON appointments(date);
CREATE INDEX idx_appointments_status ON appointments(status);
CREATE INDEX idx_jobs_vehicle_id ON jobs(vehicle_id);
CREATE INDEX idx_jobs_assigned_worker_id ON jobs(assigned_worker_id);
CREATE INDEX idx_jobs_status ON jobs(status);
CREATE INDEX idx_invoices_job_id ON invoices(job_id);
CREATE INDEX idx_invoices_payment_status ON invoices(payment_status);

-- ============================================
-- STEP 4: ENABLE ROW LEVEL SECURITY (RLS)
-- ============================================

ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE vehicles ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE invoices ENABLE ROW LEVEL SECURITY;

-- ============================================
-- STEP 5: CREATE RLS POLICIES
-- ============================================

-- ============================================
-- CUSTOMERS TABLE POLICIES
-- ============================================

-- Owner and Receptionist can view all customers
CREATE POLICY "Owner and Receptionist can view all customers"
  ON customers FOR SELECT
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can insert customers
CREATE POLICY "Owner and Receptionist can insert customers"
  ON customers FOR INSERT
  WITH CHECK (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can update customers
CREATE POLICY "Owner and Receptionist can update customers"
  ON customers FOR UPDATE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can delete customers
CREATE POLICY "Owner and Receptionist can delete customers"
  ON customers FOR DELETE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- ============================================
-- VEHICLES TABLE POLICIES
-- ============================================

-- Owner and Receptionist can view all vehicles
CREATE POLICY "Owner and Receptionist can view all vehicles"
  ON vehicles FOR SELECT
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can insert vehicles
CREATE POLICY "Owner and Receptionist can insert vehicles"
  ON vehicles FOR INSERT
  WITH CHECK (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can update vehicles
CREATE POLICY "Owner and Receptionist can update vehicles"
  ON vehicles FOR UPDATE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can delete vehicles
CREATE POLICY "Owner and Receptionist can delete vehicles"
  ON vehicles FOR DELETE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- ============================================
-- APPOINTMENTS TABLE POLICIES
-- ============================================

-- Owner, Receptionist, and Workers can view all appointments
CREATE POLICY "Staff can view all appointments"
  ON appointments FOR SELECT
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist', 'worker')
  );

-- Customers can view their own appointments
CREATE POLICY "Customers can view their own appointments"
  ON appointments FOR SELECT
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') = 'customer'
    AND customer_id = auth.uid()
  );

-- Anyone can insert appointments (for customer booking)
CREATE POLICY "Anyone can create appointments"
  ON appointments FOR INSERT
  WITH CHECK (true);

-- Owner and Receptionist can update appointments
CREATE POLICY "Owner and Receptionist can update appointments"
  ON appointments FOR UPDATE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can delete appointments
CREATE POLICY "Owner and Receptionist can delete appointments"
  ON appointments FOR DELETE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- ============================================
-- JOBS TABLE POLICIES
-- ============================================

-- Owner and Receptionist can view all jobs
CREATE POLICY "Owner and Receptionist can view all jobs"
  ON jobs FOR SELECT
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Workers can view their assigned jobs
CREATE POLICY "Workers can view assigned jobs"
  ON jobs FOR SELECT
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') = 'worker'
    AND assigned_worker_id = auth.uid()
  );

-- Owner and Receptionist can insert jobs
CREATE POLICY "Owner and Receptionist can insert jobs"
  ON jobs FOR INSERT
  WITH CHECK (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can update all jobs
CREATE POLICY "Owner and Receptionist can update jobs"
  ON jobs FOR UPDATE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Workers can update their assigned jobs
CREATE POLICY "Workers can update assigned jobs"
  ON jobs FOR UPDATE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') = 'worker'
    AND assigned_worker_id = auth.uid()
  );

-- Owner and Receptionist can delete jobs
CREATE POLICY "Owner and Receptionist can delete jobs"
  ON jobs FOR DELETE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- ============================================
-- INVOICES TABLE POLICIES
-- ============================================

-- Owner and Receptionist can view all invoices
CREATE POLICY "Owner and Receptionist can view all invoices"
  ON invoices FOR SELECT
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can insert invoices
CREATE POLICY "Owner and Receptionist can insert invoices"
  ON invoices FOR INSERT
  WITH CHECK (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can update invoices
CREATE POLICY "Owner and Receptionist can update invoices"
  ON invoices FOR UPDATE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can delete invoices
CREATE POLICY "Owner and Receptionist can delete invoices"
  ON invoices FOR DELETE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- ============================================
-- STEP 6: INSERT SAMPLE DATA
-- ============================================

-- Insert sample customers
INSERT INTO customers (name, phone, address) VALUES
  ('John Smith', '555-0101', '123 Main St, Springfield'),
  ('Sarah Johnson', '555-0102', '456 Oak Ave, Springfield'),
  ('Michael Brown', '555-0103', '789 Pine Rd, Springfield'),
  ('Emily Davis', '555-0104', '321 Elm St, Springfield');

-- Insert sample vehicles
INSERT INTO vehicles (customer_id, car_model, plate_number)
SELECT 
  c.id,
  CASE 
    WHEN c.name = 'John Smith' THEN 'Toyota Camry 2020'
    WHEN c.name = 'Sarah Johnson' THEN 'Honda Accord 2019'
    WHEN c.name = 'Michael Brown' THEN 'Ford F-150 2021'
    WHEN c.name = 'Emily Davis' THEN 'Tesla Model 3 2022'
  END,
  CASE 
    WHEN c.name = 'John Smith' THEN 'ABC-1234'
    WHEN c.name = 'Sarah Johnson' THEN 'XYZ-5678'
    WHEN c.name = 'Michael Brown' THEN 'DEF-9012'
    WHEN c.name = 'Emily Davis' THEN 'GHI-3456'
  END
FROM customers c;

-- Insert sample appointments
INSERT INTO appointments (customer_id, name, phone, car_model, problem, date, time, status)
SELECT 
  c.id,
  c.name,
  c.phone,
  v.car_model,
  CASE 
    WHEN c.name = 'John Smith' THEN 'Oil change needed'
    WHEN c.name = 'Sarah Johnson' THEN 'Brake inspection'
    ELSE 'General maintenance'
  END,
  CURRENT_DATE + INTERVAL '3 days',
  '10:00 AM',
  'Pending'
FROM customers c
JOIN vehicles v ON v.customer_id = c.id
LIMIT 3;

-- Insert sample jobs
INSERT INTO jobs (vehicle_id, issue, work_done, status, date)
SELECT 
  v.id,
  'Engine diagnostic required',
  'Completed full diagnostic scan',
  'Completed',
  CURRENT_DATE - INTERVAL '5 days'
FROM vehicles v
LIMIT 2;

-- Insert sample invoices
INSERT INTO invoices (job_id, total_amount, payment_status)
SELECT 
  j.id,
  CASE 
    WHEN j.issue LIKE '%diagnostic%' THEN 150.00
    ELSE 200.00
  END,
  'Paid'
FROM jobs j
WHERE j.status = 'Completed'
LIMIT 1;

-- ============================================
-- STEP 7: VERIFICATION QUERIES
-- ============================================

-- Verify tables were created
SELECT 
  table_name,
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name) as column_count
FROM information_schema.tables t
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
  AND table_name IN ('customers', 'vehicles', 'appointments', 'jobs', 'invoices')
ORDER BY table_name;

-- Verify RLS is enabled
SELECT 
  tablename,
  rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename IN ('customers', 'vehicles', 'appointments', 'jobs', 'invoices')
ORDER BY tablename;

-- Count policies per table
SELECT 
  schemaname,
  tablename,
  COUNT(*) as policy_count
FROM pg_policies
WHERE schemaname = 'public'
GROUP BY schemaname, tablename
ORDER BY tablename;

-- ============================================
-- SETUP COMPLETE!
-- ============================================

-- Next Steps:
-- 1. Create test users in Supabase Dashboard > Authentication > Users
-- 2. Add user_metadata with role for each user:
--    Example: {"role": "owner"}
--    Example: {"role": "receptionist"}
--    Example: {"role": "worker"}
--    Example: {"role": "customer"}
-- 3. Test the application with different roles

-- Example User Metadata Format:
-- {
--   "role": "owner"
-- }

-- Roles available:
-- - owner: Full access to all data
-- - receptionist: Manage customers, vehicles, appointments, jobs, invoices
-- - worker: View and update assigned jobs only
-- - customer: View own appointments only
