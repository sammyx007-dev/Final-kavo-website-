# KAVO Technologies Website

## Files included
- `index.html` — public homepage and all public sections
- `style.css` — responsive visual styling
- `site.js` — navigation, Supabase content loading and booking form
- `admin.html` — private admin sign-in and dashboard
- `admin.css` — dashboard styling
- `admin.js` — authentication and management of enquiries, projects, services and testimonials
- `config.js` — prefilled new Supabase project URL, publishable key, WhatsApp number and contact email
- `database-setup.sql` — database schema, RLS policies, storage bucket and starter services

## Required one-time Supabase security setup
1. Open Supabase **Authentication → Users → Add user** and create the one administrator account.
2. Copy that user's UID from the user details.
3. Open `database-setup.sql` in a text editor and replace **every** `YOUR_ADMIN_USER_UUID` with the exact UID. Keep the single quotes around the UUID.
4. Run the complete edited SQL in Supabase **SQL Editor**. `Success. No rows returned` is normal for setup SQL.
5. In **Authentication → Sign In / Providers → Email**, turn **Allow new users to sign up** OFF. Keep email/password sign-in enabled.
6. `config.js` is already populated with the supplied project URL and publishable key. Do not add any service-role or secret key.

## Deploy to Netlify
1. Upload every file in this folder to the root of a GitHub repository. Make sure `index.html` is at the repository root.
2. In Netlify select **Add new site → Import an existing project**, connect GitHub and select the repository.
3. Leave build command blank and set publish directory to `.`.
4. Deploy. Admin page: `https://YOUR-SITE.netlify.app/admin.html`.

## What works
- Responsive public website with Home, Services, About, Portfolio, Booking and Contact sections.
- Booking form attempts to save to Supabase and opens WhatsApp with a prefilled enquiry. The visitor must press Send in WhatsApp.
- Admin login uses Supabase Auth. Admin can review booking requests and update statuses; add/hide/delete projects, services and testimonials; upload portfolio images to Supabase Storage.
- Public users can submit bookings and view active content but cannot read bookings or edit content under the supplied RLS policies.

## Verify before launch
- Test a public enquiry and confirm it appears in the admin dashboard.
- Test admin login, service updates and a portfolio image upload.
- Confirm public sign-ups are disabled and the admin UUID was substituted everywhere in the SQL.
- Add only genuine testimonials with permission. Concept portfolio items are labelled as concepts.
- Contact email: `sammyx7373@gmail.com`. WhatsApp: `0802 073 7884`. The website does not claim a physical office address.
