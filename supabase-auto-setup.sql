-- ============================================
-- AUTO REPAIR CRM - AUTOMATED SUPABASE SETUP
-- ============================================
-- Execute this ENTIRE script in Supabase SQL Editor
-- This will create all tables, relationships, RLS policies, and sample data
-- User creation must be done via Supabase Dashboard (see instructions below)

-- ============================================
-- STEP 1: CLEAN SLATE (Drop existing tables)
-- ============================================

DROP TABLE IF EXISTS invoices CASCADE;
DROP TABLE IF EXISTS jobs CASCADE;
DROP TABLE IF EXISTS appointments CASCADE;
DROP TABLE IF EXISTS vehicles CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

-- ============================================
-- STEP 2: CREATE TABLES WITH RELATIONSHIPS
-- ============================================

-- Create customers table
CREATE TABLE customers (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  address TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create vehicles table with foreign key to customers
CREATE TABLE vehicles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  car_model TEXT NOT NULL,
  plate_number TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create appointments table with optional customer link
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

-- Create jobs table with foreign keys
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

-- Create invoices table with foreign key to jobs
CREATE TABLE invoices (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  total_amount NUMERIC(10, 2) NOT NULL,
  payment_status TEXT DEFAULT 'Unpaid' CHECK (payment_status IN ('Paid', 'Unpaid', 'Partial')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- STEP 3: CREATE PERFORMANCE INDEXES
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

-- ==================== CUSTOMERS POLICIES ====================

-- Owner and Receptionist can view all customers
CREATE POLICY "owner_receptionist_view_customers"
  ON customers FOR SELECT
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can insert customers
CREATE POLICY "owner_receptionist_insert_customers"
  ON customers FOR INSERT
  WITH CHECK (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can update customers
CREATE POLICY "owner_receptionist_update_customers"
  ON customers FOR UPDATE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can delete customers
CREATE POLICY "owner_receptionist_delete_customers"
  ON customers FOR DELETE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- ==================== VEHICLES POLICIES ====================

-- Owner and Receptionist can view all vehicles
CREATE POLICY "owner_receptionist_view_vehicles"
  ON vehicles FOR SELECT
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can insert vehicles
CREATE POLICY "owner_receptionist_insert_vehicles"
  ON vehicles FOR INSERT
  WITH CHECK (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can update vehicles
CREATE POLICY "owner_receptionist_update_vehicles"
  ON vehicles FOR UPDATE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can delete vehicles
CREATE POLICY "owner_receptionist_delete_vehicles"
  ON vehicles FOR DELETE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- ==================== APPOINTMENTS POLICIES ====================

-- Staff can view all appointments
CREATE POLICY "staff_view_appointments"
  ON appointments FOR SELECT
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist', 'worker')
  );

-- Customers can view their own appointments
CREATE POLICY "customer_view_own_appointments"
  ON appointments FOR SELECT
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') = 'customer'
    AND customer_id = auth.uid()
  );

-- Anyone authenticated can create appointments (for booking)
CREATE POLICY "authenticated_create_appointments"
  ON appointments FOR INSERT
  WITH CHECK (auth.uid() IS NOT NULL);

-- Owner and Receptionist can update appointments
CREATE POLICY "owner_receptionist_update_appointments"
  ON appointments FOR UPDATE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can delete appointments
CREATE POLICY "owner_receptionist_delete_appointments"
  ON appointments FOR DELETE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- ==================== JOBS POLICIES ====================

-- Owner and Receptionist can view all jobs
CREATE POLICY "owner_receptionist_view_jobs"
  ON jobs FOR SELECT
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Workers can view their assigned jobs
CREATE POLICY "worker_view_assigned_jobs"
  ON jobs FOR SELECT
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') = 'worker'
    AND assigned_worker_id = auth.uid()
  );

-- Owner and Receptionist can insert jobs
CREATE POLICY "owner_receptionist_insert_jobs"
  ON jobs FOR INSERT
  WITH CHECK (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can update all jobs
CREATE POLICY "owner_receptionist_update_jobs"
  ON jobs FOR UPDATE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Workers can update their assigned jobs
CREATE POLICY "worker_update_assigned_jobs"
  ON jobs FOR UPDATE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') = 'worker'
    AND assigned_worker_id = auth.uid()
  );

-- Owner and Receptionist can delete jobs
CREATE POLICY "owner_receptionist_delete_jobs"
  ON jobs FOR DELETE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- ==================== INVOICES POLICIES ====================

-- Owner and Receptionist can view all invoices
CREATE POLICY "owner_receptionist_view_invoices"
  ON invoices FOR SELECT
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can insert invoices
CREATE POLICY "owner_receptionist_insert_invoices"
  ON invoices FOR INSERT
  WITH CHECK (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can update invoices
CREATE POLICY "owner_receptionist_update_invoices"
  ON invoices FOR UPDATE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- Owner and Receptionist can delete invoices
CREATE POLICY "owner_receptionist_delete_invoices"
  ON invoices FOR DELETE
  USING (
    (auth.jwt() -> 'user_metadata' ->> 'role') IN ('owner', 'receptionist')
  );

-- ============================================
-- STEP 6: INSERT SAMPLE DATA
-- ============================================

-- Insert sample customers
INSERT INTO customers (name, phone, address) VALUES
  ('John Smith', '555-0101', '123 Main St, Springfield, IL 62701'),
  ('Sarah Johnson', '555-0102', '456 Oak Ave, Springfield, IL 62702'),
  ('Michael Brown', '555-0103', '789 Pine Rd, Springfield, IL 62703'),
  ('Emily Davis', '555-0104', '321 Elm St, Springfield, IL 62704'),
  ('David Wilson', '555-0105', '654 Maple Dr, Springfield, IL 62705');

-- Insert sample vehicles
INSERT INTO vehicles (customer_id, car_model, plate_number)
SELECT 
  c.id,
  CASE 
    WHEN c.name = 'John Smith' THEN 'Toyota Camry 2020'
    WHEN c.name = 'Sarah Johnson' THEN 'Honda Accord 2019'
    WHEN c.name = 'Michael Brown' THEN 'Ford F-150 2021'
    WHEN c.name = 'Emily Davis' THEN 'Tesla Model 3 2022'
    WHEN c.name = 'David Wilson' THEN 'Chevrolet Silverado 2020'
  END,
  CASE 
    WHEN c.name = 'John Smith' THEN 'ABC-1234'
    WHEN c.name = 'Sarah Johnson' THEN 'XYZ-5678'
    WHEN c.name = 'Michael Brown' THEN 'DEF-9012'
    WHEN c.name = 'Emily Davis' THEN 'GHI-3456'
    WHEN c.name = 'David Wilson' THEN 'JKL-7890'
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
    WHEN c.name = 'John Smith' THEN 'Oil change and filter replacement needed'
    WHEN c.name = 'Sarah Johnson' THEN 'Brake inspection and possible pad replacement'
    WHEN c.name = 'Michael Brown' THEN 'Engine making strange noise, needs diagnostic'
    ELSE 'General maintenance and inspection'
  END,
  CURRENT_DATE + INTERVAL '3 days',
  CASE 
    WHEN c.name = 'John Smith' THEN '09:00 AM'
    WHEN c.name = 'Sarah Johnson' THEN '10:30 AM'
    WHEN c.name = 'Michael Brown' THEN '02:00 PM'
    ELSE '11:00 AM'
  END,
  CASE 
    WHEN c.name = 'John Smith' THEN 'Confirmed'
    ELSE 'Pending'
  END
FROM customers c
JOIN vehicles v ON v.customer_id = c.id
LIMIT 4;

-- Insert sample jobs
INSERT INTO jobs (vehicle_id, issue, work_done, status, date)
SELECT 
  v.id,
  CASE 
    WHEN v.car_model LIKE '%Toyota%' THEN 'Complete engine diagnostic and oil change'
    WHEN v.car_model LIKE '%Honda%' THEN 'Brake system inspection and pad replacement'
    ELSE 'Transmission fluid check and tire rotation'
  END,
  CASE 
    WHEN v.car_model LIKE '%Toyota%' THEN 'Completed full diagnostic scan, changed oil and filter, checked all fluid levels'
    WHEN v.car_model LIKE '%Honda%' THEN 'Replaced front brake pads, resurfaced rotors, tested brake system'
    ELSE NULL
  END,
  CASE 
    WHEN v.car_model LIKE '%Toyota%' THEN 'Completed'
    WHEN v.car_model LIKE '%Honda%' THEN 'Completed'
    ELSE 'In Progress'
  END,
  CASE 
    WHEN v.car_model LIKE '%Toyota%' THEN CURRENT_DATE - INTERVAL '5 days'
    WHEN v.car_model LIKE '%Honda%' THEN CURRENT_DATE - INTERVAL '3 days'
    ELSE CURRENT_DATE
  END
FROM vehicles v
LIMIT 3;

-- Insert sample invoices for completed jobs
INSERT INTO invoices (job_id, total_amount, payment_status)
SELECT 
  j.id,
  CASE 
    WHEN j.issue LIKE '%diagnostic%' THEN 175.00
    WHEN j.issue LIKE '%brake%' THEN 285.00
    ELSE 150.00
  END,
  CASE 
    WHEN j.status = 'Completed' AND j.issue LIKE '%diagnostic%' THEN 'Paid'
    WHEN j.status = 'Completed' THEN 'Unpaid'
    ELSE 'Unpaid'
  END
FROM jobs j
WHERE j.status = 'Completed';

-- ============================================
-- STEP 7: CREATE HELPER FUNCTION FOR USER SETUP
-- ============================================

-- Function to help verify user roles (for debugging)
CREATE OR REPLACE FUNCTION get_user_role()
RETURNS TEXT
LANGUAGE SQL
SECURITY DEFINER
AS $$
  SELECT COALESCE(
    auth.jwt() -> 'user_metadata' ->> 'role',
    'no_role'
  );
$$;

-- ============================================
-- STEP 8: VERIFICATION QUERIES
-- ============================================

-- Verify all tables were created
DO $$
DECLARE
  table_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO table_count
  FROM information_schema.tables
  WHERE table_schema = 'public'
    AND table_name IN ('customers', 'vehicles', 'appointments', 'jobs', 'invoices');
  
  RAISE NOTICE '✅ Tables created: % out of 5', table_count;
END $$;

-- Verify RLS is enabled
DO $$
DECLARE
  rls_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO rls_count
  FROM pg_tables
  WHERE schemaname = 'public'
    AND tablename IN ('customers', 'vehicles', 'appointments', 'jobs', 'invoices')
    AND rowsecurity = true;
  
  RAISE NOTICE '✅ RLS enabled on: % out of 5 tables', rls_count;
END $$;

-- Count RLS policies
DO $$
DECLARE
  policy_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO policy_count
  FROM pg_policies
  WHERE schemaname = 'public';
  
  RAISE NOTICE '✅ RLS policies created: %', policy_count;
END $$;

-- Verify sample data
DO $$
DECLARE
  customer_count INTEGER;
  vehicle_count INTEGER;
  appointment_count INTEGER;
  job_count INTEGER;
  invoice_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO customer_count FROM customers;
  SELECT COUNT(*) INTO vehicle_count FROM vehicles;
  SELECT COUNT(*) INTO appointment_count FROM appointments;
  SELECT COUNT(*) INTO job_count FROM jobs;
  SELECT COUNT(*) INTO invoice_count FROM invoices;
  
  RAISE NOTICE '✅ Sample data inserted:';
  RAISE NOTICE '   - Customers: %', customer_count;
  RAISE NOTICE '   - Vehicles: %', vehicle_count;
  RAISE NOTICE '   - Appointments: %', appointment_count;
  RAISE NOTICE '   - Jobs: %', job_count;
  RAISE NOTICE '   - Invoices: %', invoice_count;
END $$;

-- ============================================
-- SETUP COMPLETE! 
-- ============================================

-- Display summary
DO $$
BEGIN
  RAISE NOTICE '';
  RAISE NOTICE '╔════════════════════════════════════════════════════════╗';
  RAISE NOTICE '║     ✅ SUPABASE BACKEND SETUP COMPLETE!               ║';
  RAISE NOTICE '╚════════════════════════════════════════════════════════╝';
  RAISE NOTICE '';
  RAISE NOTICE '📊 Database Status:';
  RAISE NOTICE '   ✅ 5 tables created with relationships';
  RAISE NOTICE '   ✅ 9 performance indexes created';
  RAISE NOTICE '   ✅ RLS enabled on all tables';
  RAISE NOTICE '   ✅ 20+ RLS policies created';
  RAISE NOTICE '   ✅ Sample data inserted';
  RAISE NOTICE '';
  RAISE NOTICE '👥 IMPORTANT - Create Test Users:';
  RAISE NOTICE '   Go to: Authentication → Users → Add User';
  RAISE NOTICE '';
  RAISE NOTICE '   Create 4 users with these details:';
  RAISE NOTICE '';
  RAISE NOTICE '   1️⃣ OWNER';
  RAISE NOTICE '      Email: owner@autorepair.com';
  RAISE NOTICE '      Password: owner123456';
  RAISE NOTICE '      User Metadata: {"role": "owner"}';
  RAISE NOTICE '';
  RAISE NOTICE '   2️⃣ RECEPTIONIST';
  RAISE NOTICE '      Email: receptionist@autorepair.com';
  RAISE NOTICE '      Password: receptionist123456';
  RAISE NOTICE '      User Metadata: {"role": "receptionist"}';
  RAISE NOTICE '';
  RAISE NOTICE '   3️⃣ WORKER';
  RAISE NOTICE '      Email: worker@autorepair.com';
  RAISE NOTICE '      Password: worker123456';
  RAISE NOTICE '      User Metadata: {"role": "worker"}';
  RAISE NOTICE '';
  RAISE NOTICE '   4️⃣ CUSTOMER';
  RAISE NOTICE '      Email: customer@autorepair.com';
  RAISE NOTICE '      Password: customer123456';
  RAISE NOTICE '      User Metadata: {"role": "customer"}';
  RAISE NOTICE '';
  RAISE NOTICE '🔑 Get Your Credentials:';
  RAISE NOTICE '   Settings → API';
  RAISE NOTICE '   - Copy Project URL';
  RAISE NOTICE '   - Copy anon/public key';
  RAISE NOTICE '   - Update .env file';
  RAISE NOTICE '';
  RAISE NOTICE '🚀 Next: Run your application!';
  RAISE NOTICE '   npm run dev';
  RAISE NOTICE '';
END $$;
