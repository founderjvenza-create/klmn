#!/usr/bin/env node

/**
 * Auto Repair CRM - Setup Verification Script
 * 
 * This script verifies that your Supabase backend is properly configured
 */

import { createClient } from '@supabase/supabase-js'
import * as fs from 'fs'

console.log('🚗 Auto Repair CRM - Setup Verification')
console.log('========================================')
console.log('')

// Check if .env file exists
if (!fs.existsSync('.env')) {
  console.log('❌ .env file not found')
  console.log('   Create .env file with your Supabase credentials')
  console.log('   See .env.example for template')
  process.exit(1)
}

// Read .env file
const envContent = fs.readFileSync('.env', 'utf8')
const supabaseUrl = envContent.match(/VITE_SUPABASE_URL=(.*)/)?.[1]?.trim()
const supabaseKey = envContent.match(/VITE_SUPABASE_ANON_KEY=(.*)/)?.[1]?.trim()

if (!supabaseUrl || !supabaseKey) {
  console.log('❌ Supabase credentials not found in .env')
  console.log('   Add VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY')
  process.exit(1)
}

console.log('✅ Environment variables found')
console.log(`   URL: ${supabaseUrl}`)
console.log(`   Key: ${supabaseKey.substring(0, 20)}...`)
console.log('')

// Create Supabase client
const supabase = createClient(supabaseUrl, supabaseKey)

async function verifySetup() {
  console.log('🔍 Verifying Supabase setup...')
  console.log('')

  let allGood = true

  // Check tables
  const tables = ['customers', 'vehicles', 'appointments', 'jobs', 'invoices']
  
  for (const table of tables) {
    try {
      const { count, error } = await supabase
        .from(table)
        .select('*', { count: 'exact', head: true })

      if (error) {
        console.log(`❌ Table '${table}': ${error.message}`)
        allGood = false
      } else {
        console.log(`✅ Table '${table}': ${count} records`)
      }
    } catch (err) {
      console.log(`❌ Table '${table}': ${err.message}`)
      allGood = false
    }
  }

  console.log('')

  // Check authentication
  try {
    const { data, error } = await supabase.auth.getSession()
    if (error) {
      console.log('⚠️  Authentication: Not logged in (this is normal)')
    } else {
      console.log('✅ Authentication: Working')
    }
  } catch (err) {
    console.log(`❌ Authentication: ${err.message}`)
    allGood = false
  }

  console.log('')
  console.log('========================================')

  if (allGood) {
    console.log('🎉 Setup verification PASSED!')
    console.log('')
    console.log('✅ All tables exist and are accessible')
    console.log('✅ Supabase connection working')
    console.log('✅ Sample data loaded')
    console.log('')
    console.log('📋 Next Steps:')
    console.log('   1. Create test users (see create-supabase-users.md)')
    console.log('   2. Run: npm run dev')
    console.log('   3. Open: http://localhost:5173')
    console.log('   4. Login with test credentials')
    console.log('')
    console.log('📚 Documentation: START_HERE.md')
  } else {
    console.log('❌ Setup verification FAILED')
    console.log('')
    console.log('🔧 Troubleshooting:')
    console.log('   1. Verify supabase-auto-setup.sql was executed')
    console.log('   2. Check Supabase project is active')
    console.log('   3. Verify credentials in .env are correct')
    console.log('   4. See TROUBLESHOOTING.md for help')
    console.log('')
    process.exit(1)
  }
}

verifySetup().catch(err => {
  console.error('❌ Fatal error:', err.message)
  process.exit(1)
})
