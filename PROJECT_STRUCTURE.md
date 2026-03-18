# Project Structure

```
auto-repair-crm/
├── public/                          # Static assets
├── src/
│   ├── components/                  # Reusable UI components
│   │   ├── ConfirmDialog.jsx       # Confirmation dialog for destructive actions
│   │   ├── Layout.jsx              # Main layout with sidebar and navbar
│   │   ├── Modal.jsx               # Reusable modal component
│   │   └── StatusBadge.jsx         # Status indicator badges
│   │
│   ├── contexts/                    # React Context providers
│   │   └── AuthContext.jsx         # Authentication state and methods
│   │
│   ├── lib/                         # Utility libraries
│   │   └── supabase.js             # Supabase client configuration
│   │
│   ├── pages/                       # Page components (routes)
│   │   ├── Appointments.jsx        # Appointment management
│   │   ├── CustomerBooking.jsx     # Customer self-service booking
│   │   ├── Customers.jsx           # Customer CRUD operations
│   │   ├── Dashboard.jsx           # Role-based dashboard
│   │   ├── Invoices.jsx            # Invoice management
│   │   ├── JobCards.jsx            # Job card management
│   │   ├── Login.jsx               # Login page
│   │   ├── Signup.jsx              # Registration page
│   │   └── Vehicles.jsx            # Vehicle management
│   │
│   ├── App.jsx                      # Main app component with routing
│   ├── index.css                    # Global styles and Tailwind imports
│   └── main.jsx                     # App entry point
│
├── .env                             # Environment variables (not in git)
├── .env.example                     # Environment variables template
├── .gitignore                       # Git ignore rules
├── index.html                       # HTML entry point
├── package.json                     # Dependencies and scripts
├── postcss.config.js                # PostCSS configuration
├── tailwind.config.js               # Tailwind CSS configuration
├── vercel.json                      # Vercel deployment config
├── vite.config.js                   # Vite build configuration
│
├── supabase-setup.sql               # Database schema and RLS policies
│
├── README.md                        # Main documentation
├── QUICKSTART.md                    # Quick start guide
├── DEPLOYMENT.md                    # Deployment instructions
├── FEATURES.md                      # Feature documentation
└── PROJECT_STRUCTURE.md             # This file
```

## Directory Details

### `/src/components`
Reusable UI components used across multiple pages.

**ConfirmDialog.jsx**
- Confirmation modal for destructive actions
- Used before deleting customers, vehicles, etc.
- Props: isOpen, onClose, onConfirm, title, message

**Layout.jsx**
- Main application layout wrapper
- Responsive sidebar navigation
- Top navbar with user info
- Role-based menu filtering
- Mobile-friendly collapsible sidebar

**Modal.jsx**
- Generic modal component
- Used for forms and detail views
- Props: isOpen, onClose, title, children

**StatusBadge.jsx**
- Color-coded status indicators
- Supports multiple status types
- Consistent styling across app

### `/src/contexts`
React Context providers for global state management.

**AuthContext.jsx**
- Authentication state management
- User session handling
- Sign up, sign in, sign out methods
- Role-based access control
- Supabase auth integration

### `/src/lib`
Utility libraries and configurations.

**supabase.js**
- Supabase client initialization
- Environment variable configuration
- Exported for use across app

### `/src/pages`
Page-level components mapped to routes.

**Dashboard.jsx**
- Role-based dashboard
- Statistics and metrics
- Quick action cards
- Different views per role

**Customers.jsx**
- Customer list with search
- CRUD operations
- Modal forms
- Delete confirmations

**Vehicles.jsx**
- Vehicle management
- Customer relationship
- Search and filter
- CRUD operations

**Appointments.jsx**
- Appointment viewing
- Status filtering
- Search functionality
- Detail modal

**JobCards.jsx**
- Job card management
- Worker assignment
- Status updates
- Cost tracking

**Invoices.jsx**
- Invoice generation
- Payment tracking
- Status management
- Billing details

**CustomerBooking.jsx**
- Self-service booking
- Vehicle selection
- Service type picker
- Date selection

**Login.jsx**
- User authentication
- Email/password login
- Error handling

**Signup.jsx**
- User registration
- Role selection
- Account creation

## Configuration Files

### `vite.config.js`
- Vite build configuration
- React plugin setup
- Development server settings

### `tailwind.config.js`
- Tailwind CSS customization
- Custom color palette
- Content paths for purging

### `postcss.config.js`
- PostCSS plugins
- Tailwind and Autoprefixer

### `vercel.json`
- SPA routing configuration
- Deployment settings

### `package.json`
- Project dependencies
- Build scripts
- Project metadata

## Database Schema

### Tables
1. **customers**: Customer information
2. **vehicles**: Vehicle details linked to customers
3. **appointments**: Service appointments
4. **job_cards**: Work orders for repairs
5. **invoices**: Billing and payments

### Relationships
```
customers (1) ──→ (many) vehicles
vehicles (1) ──→ (many) appointments
appointments (1) ──→ (1) job_cards
job_cards (1) ──→ (1) invoices
```

## Routing Structure

```
/                           → Redirect to /dashboard
/login                      → Login page (public)
/signup                     → Signup page (public)
/dashboard                  → Dashboard (all roles)
/customers                  → Customers (owner, reception)
/vehicles                   → Vehicles (owner, reception)
/appointments               → Appointments (all roles)
/job-cards                  → Job Cards (owner, reception, worker)
/invoices                   → Invoices (owner, reception)
/booking                    → Customer Booking (customer)
```

## Component Hierarchy

```
App
├── AuthProvider
│   └── BrowserRouter
│       └── Routes
│           ├── Login
│           ├── Signup
│           └── ProtectedRoute
│               └── Layout
│                   ├── Sidebar
│                   ├── Navbar
│                   └── Page Content
│                       ├── Dashboard
│                       ├── Customers
│                       ├── Vehicles
│                       ├── Appointments
│                       ├── JobCards
│                       ├── Invoices
│                       └── CustomerBooking
```

## State Management

### Global State (Context)
- User authentication
- User role
- Session management

### Local State (Component)
- Form data
- Modal visibility
- Search/filter values
- Loading states
- Selected items

### Server State (Supabase)
- Database records
- Real-time updates
- Authentication state

## Styling Approach

### Tailwind CSS
- Utility-first CSS framework
- Custom color configuration
- Responsive design utilities
- Component-specific styles

### Design Tokens
```javascript
colors: {
  primary: '#dc6625',
  secondary: '#487fc5',
  accent: '#dc6625'
}
```

## Build Process

1. **Development**: `npm run dev`
   - Vite dev server
   - Hot module replacement
   - Fast refresh

2. **Production**: `npm run build`
   - Optimized bundle
   - Code splitting
   - Asset optimization

3. **Preview**: `npm run preview`
   - Test production build locally

## Environment Variables

Required variables in `.env`:
```
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

## Key Dependencies

### Core
- `react` - UI library
- `react-dom` - React DOM rendering
- `react-router-dom` - Routing

### Backend
- `@supabase/supabase-js` - Supabase client

### UI
- `tailwindcss` - CSS framework
- `lucide-react` - Icon library
- `react-hot-toast` - Notifications

### Build Tools
- `vite` - Build tool
- `@vitejs/plugin-react` - React plugin

## Code Organization Principles

1. **Separation of Concerns**: Components, pages, contexts, and utilities are separated
2. **Reusability**: Common components are extracted and reused
3. **Single Responsibility**: Each component has one clear purpose
4. **DRY**: Don't Repeat Yourself - shared logic is abstracted
5. **Consistency**: Naming conventions and patterns are consistent

## Naming Conventions

- **Components**: PascalCase (e.g., `CustomerBooking.jsx`)
- **Utilities**: camelCase (e.g., `supabase.js`)
- **Constants**: UPPER_SNAKE_CASE
- **CSS Classes**: kebab-case (Tailwind utilities)
- **Database Tables**: snake_case (e.g., `job_cards`)

## Best Practices

1. Always use environment variables for sensitive data
2. Implement proper error handling
3. Show loading states during async operations
4. Provide user feedback with toast notifications
5. Validate forms before submission
6. Use confirmation dialogs for destructive actions
7. Keep components small and focused
8. Write descriptive prop types
9. Follow React hooks rules
10. Maintain consistent code formatting
