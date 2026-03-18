# Auto Repair CRM - Modern Web Application

A comprehensive Auto Repair CRM and Customer Booking System built with React, Tailwind CSS, and Supabase.

## Features

### Role-Based Access Control
- **Owner**: Full dashboard access, view all data and analytics
- **Reception**: Manage customers, vehicles, appointments, job cards, and invoices
- **Worker**: View assigned jobs, update job status
- **Customer**: Book appointments, view job status

### Core Functionality
- Customer management with full CRUD operations
- Vehicle tracking and management
- Appointment booking system
- Job card creation and status tracking (Pending → In Progress → Done)
- Invoice generation and payment tracking
- Real-time search and filtering
- Status badges and visual indicators
- Toast notifications for user feedback
- Confirmation dialogs for destructive actions
- Fully responsive mobile and desktop design

## Tech Stack

- **Frontend**: React 18 + Vite
- **Styling**: Tailwind CSS
- **Backend**: Supabase (PostgreSQL + Auth)
- **Icons**: Lucide React
- **Notifications**: React Hot Toast
- **Routing**: React Router DOM
- **Deployment**: Vercel-ready

## Color Scheme

- Primary: `#dc6625` (Orange)
- Secondary: `#487fc5` (Blue)
- Background: `#ffffff` (White)
- Text: `#000000` (Black)
- Accent: `#dc6625` (Orange)

## Setup Instructions

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure Environment Variables

Create a `.env` file in the root directory:

```env
VITE_SUPABASE_URL=https://xtivjbeuxajkeltlbjgt.supabase.co
VITE_SUPABASE_ANON_KEY=sb_publishable_nbXhrhE5dGJTR5cmnayBzA_qhLtiNMDAuthentication
```

### 3. Setup Supabase Database

1. Go to your Supabase project dashboard
2. Navigate to SQL Editor
3. Copy and paste the contents of `supabase-setup.sql`
4. Execute the SQL to create tables and RLS policies

**📖 For detailed setup instructions, see [SUPABASE_SETUP_GUIDE.md](SUPABASE_SETUP_GUIDE.md)**

### 4. Create Test Users

1. In Supabase Dashboard, go to Authentication → Users
2. Create test users for each role (owner, receptionist, worker, customer)
3. Add role to user metadata: `{"role": "owner"}`

**📖 For test user credentials, see [TEST_USERS.md](TEST_USERS.md)**

### 5. Run Development Server

```bash
npm run dev
```

The app will be available at `http://localhost:5173`

### 6. Build for Production

```bash
npm run build
```

## Deployment to Vercel

1. Push your code to GitHub
2. Import project in Vercel
3. Add environment variables in Vercel project settings:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
4. Deploy

The `vercel.json` file is already configured for SPA routing.

## Database Schema

### Tables

- **customers**: Customer information (name, email, phone, address)
- **vehicles**: Vehicle details linked to customers
- **appointments**: Service appointments with status tracking
- **job_cards**: Work orders for repairs with worker assignment
- **invoices**: Billing and payment tracking

### Row Level Security (RLS)

All tables have RLS enabled with policies based on user roles:
- Customers see only their own data
- Workers see only assigned jobs
- Reception manages customers, vehicles, appointments, and invoices
- Owner has full access to everything

## User Roles

Roles are stored in `auth.users.user_metadata.role`:
- `customer`
- `worker`
- `reception`
- `owner`

## Pages

- `/login` - User authentication
- `/signup` - New user registration
- `/dashboard` - Role-based dashboard with statistics
- `/customers` - Customer management (Owner, Reception)
- `/vehicles` - Vehicle management (Owner, Reception)
- `/appointments` - Appointment viewing and management
- `/job-cards` - Job card management with status updates
- `/invoices` - Invoice creation and payment tracking
- `/booking` - Customer self-service booking (Customers only)

## Key Components

- **Layout**: Responsive sidebar navigation with top navbar
- **Modal**: Reusable modal for forms and details
- **StatusBadge**: Color-coded status indicators
- **ConfirmDialog**: Confirmation prompts for destructive actions

## Features Highlights

### Search & Filter
- Real-time search across all data tables
- Status-based filtering for appointments, job cards, and invoices

### Status Workflow
- Appointments: Pending → Confirmed → Completed
- Job Cards: Pending → In Progress → Done
- Invoices: Unpaid → Paid

### Responsive Design
- Mobile-first approach
- Collapsible sidebar on mobile
- Touch-friendly interface
- Optimized table layouts

## Support

For issues or questions, please refer to the documentation or contact support.

## License

MIT License
