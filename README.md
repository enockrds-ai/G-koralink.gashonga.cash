# G-KORALINK

Gashonga KoraLink Saving — Ruby on Rails 8 + PostgreSQL (Supabase).

## Free deployment

This repository is prepared for a free Render Web Service. The application uses the existing Supabase PostgreSQL database, so the Render filesystem is not used for persistent data.

1. Open Render and choose **New → Web Service**.
2. Connect this GitHub repository and branch **main**.
3. Choose the **Free** plan.
4. Set:
   - `RAILS_ENV=production`
   - `DATABASE_URL` = the Supabase PostgreSQL connection string
   - `SECRET_KEY_BASE` = a long random Rails secret
5. Health check: `/health`.
6. Start command: `bundle exec puma -b tcp://0.0.0.0:$PORT server.ru`.

Do not put database credentials or secret keys in GitHub.

The existing Floot application should remain online until the new deployment is tested and the migrated Supabase data is verified.
