# E-ZIGAME / G-KORALINK — Backup & Migration Plan

## Current source backup
The Rails fallback source is maintained in this repository:
- Repository: enockrds-ai/G-koralink.gashonga.cash
- Target host: Render
- Database target: Supabase PostgreSQL

## Floot backup requirements
Floot documents two separate exports:
1. Code: Floot project menu → Get Code → Download as ZIP. This is a browser download and requires a paid Floot plan.
2. Database: Services → Data → Floot database → table → cog → Export → Download Database. The database export is a pg_dump and is available on any plan while hosting is still active.

Do NOT wait until Floot hosting is taken down for an unpaid balance before downloading the database; Floot says database download is unavailable after hosting is taken down until the balance is paid.

## Migration target
The preferred target is PostgreSQL on Supabase plus the Rails application in this repository. The app should not depend on Floot hosting for production.

## Data already migrated
The G-KORALINK Supabase project is active and contains the migrated application data. Before cutover, verify row counts and business totals against Floot.

## Cutover checklist
- [ ] Download Floot source ZIP from the browser.
- [ ] Download Floot PostgreSQL pg_dump from the browser.
- [ ] Store the dump securely; never commit credentials or password hashes.
- [ ] Restore/verify data in Supabase.
- [ ] Ensure Rails Gemfile.lock is committed.
- [ ] Configure DATABASE_URL and Rails secrets on the host.
- [ ] Run Rails database/schema checks.
- [ ] Test login, registration, savings approval, fines, loans, repayments, notifications, member directory, group chat, and hot-money dashboard.
- [ ] Verify the production totals before switching users.
- [ ] Keep E-ZIGAME on Floot until the replacement passes verification.
- [ ] Only after verification, switch the public URL.

## Important business rules to preserve
- 1 share = RWF 500.
- Maximum 8 shares per week = RWF 4,000.
- Scheduled savings window: Tuesday 17:00 through Wednesday 15:00 Kigali time.
- No savings fine inside that window.
- Outside that window, fine = RWF 100 per share.
- Fine is counted only when the saving is approved.
- Loan maximum = 80% of the communal available pool.
- Member may request a loan even with zero personal savings.
- Preserve IMARI ISHYUSYE / hot-money dashboard.
- Do not add app-wide auto-refresh.

## Security
Never put Supabase database passwords, Rails master key, session secrets, API keys, password hashes, or other credentials into GitHub.
