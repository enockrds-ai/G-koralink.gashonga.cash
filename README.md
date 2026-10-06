# G-KORALINK Gashonga

Rails + PostgreSQL savings group platform. Connects to the existing G-KORALINK PostgreSQL database in Supabase.

## Run

Set `DATABASE_URL` and `SECRET_KEY_BASE`, then:

```bash
bundle install
bin/rails server
```

The app uses the existing database tables and does not reset or delete existing G-KORALINK data.
