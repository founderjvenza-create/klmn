#!/usr/bin/env node

/**
 * Auto Repair CRM - Automated User Creation Script
 * 
 * This script automatically creates test users in Supabase
 * Requires: @supabase/supabase-js
 * 
 * Usage:
 *   1. Get your SERVICE_ROLE_KEY from Supabase Dashboard → Settings → API
 *   2. Run: SUPABASE_URL=your_url SERVICE_KEY=your_key node create-users.js
 */

import { createClient } from '@supabase/supabase-js'

// Get credentials from environment or command line
const supabaseUrl = process.env.SUPABASE_URL || process.env.VITE_SUPABASE_URL
const serviceKey = process.env.SERVICE_KEY || process.env.SUPABASE_SERVICE_KEY

if (!supabaseUrl || !serviceKey) {
  console.error('❌ Error: Missing credentials')
  console.log('')
  console.log('Usage:')
  console.log('  SUPABASE_URL=your_url SERVICE_KEY=your_service_key node create-users.js')
  console.log('')
  console.log('Get your SERVICE_ROLE_KEY from:')
  console.log('  Supabase Dashboard → Settings → API → service_role key')
  console.log('')
  console.log('⚠️  WARNING: Keep service_role key secret! Never commit to git!')
  process.exit(1)
}

// Create Supabase admin client
const supabase = createClient(supabaseUrl, serviceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
})

// Test users to create
const users = [
  {
    email: 'owner@autorepair.com',
    password: 'owner123456',
    role: 'owner',
    description: 'Full system access, analytics, oversight'
  },
  {
    email: 'receptionist@autorepair.com',
    password: 'receptionist123456',
    role: 'receptionist',
    description: 'Customer management, appointments, invoicing'
  },
  {
    email: 'worker@autorepair.com',
    password: 'worker123456',
    role: 'worker',
    description: 'View assigned jobs, update status'
  },
  {
    email: 'customer@autorepair.com',
    password: 'customer123456',
    role: 'customer',
    description: 'Book appointments, track status'
  }
]

async function createUsers() {
  console.log('🚗 Auto Repair CRM - User Creation')
  console.log('===================================')
  console.log('')
  console.log('🚀 Creating test users in Supabase...')
  console.log('')

  let successCount = 0
  let errorCount = 0

  for (const user of users) {
    try {
      const { data, error } = await supabase.auth.admin.createUser({
        email: user.email,
        password: user.password,
        email_confirm: true,
        user_metadata: {
          role: user.role
        }
      })

      if (error) {
        // Check if user already exists
        if (error.message.includes('already registered')) {
          console.log(`⚠️  ${user.role.toUpperCase()}: Already exists (${user.email})`)
        } else {
          console.log(`❌ ${user.role.toUpperCase()}: Error - ${error.message}`)
          errorCount++
        }
      } else {
        console.log(`✅ ${user.role.toUpperCase()}: Created successfully`)
        console.log(`   Email: ${user.email}`)
        console.log(`   Password: ${user.password}`)
        console.log(`   Role: ${user.role}`)
        console.log('')
        successCount++
      }
    } catch (err) {
      console.log(`❌ ${user.role.toUpperCase()}: Exception - ${err.message}`)
      errorCount++
    }
  }

  console.log('===================================')
  console.log(`✅ Successfully created: ${successCount} users`)
  if (errorCount > 0) {
    console.log(`❌ Errors: ${errorCount}`)
  }
  console.log('')

  // Display login credentials
  console.log('📋 Login Credentials:')
  console.log('===================================')
  console.log('')
  
  users.forEach(user => {
    console.log(`${user.role.toUpperCase()}:`)
    console.log(`  Email: ${user.email}`)
    console.log(`  Password: ${user.password}`)
    console.log(`  Access: ${user.description}`)
    console.log('')
  })

  console.log('===================================')
  console.log('🎉 User creation complete!')
  console.log('')
  console.log('🚀 Next Steps:')
  console.log('   1. Run: npm run dev')
  console.log('   2. Open: http://localhost:5173')
  console.log('   3. Login with any of the credentials above')
  console.log('')
  console.log('📚 Documentation:')
  console.log('   - Quick Start: QUICKSTART.md')
  console.log('   - Test Users: TEST_USERS.md')
  console.log('   - Full Guide: START_HERE.md')
  console.log('')
}

// Run the script
createUsers().catch(err => {
  console.error('❌ Fatal error:', err.message)
  process.exit(1)
})
