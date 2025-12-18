-- psql -f setup.sql

\i 'scripts/99-reset.sql'
\i 'scripts/00-users.sql'
\i 'scripts/01-domains.sql'
\i 'scripts/02-schema.sql'
\i 'scripts/03-indexes.sql'
\i 'scripts/04-views.sql'
\i 'scripts/05-seed.sql'